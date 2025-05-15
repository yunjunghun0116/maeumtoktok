import 'package:app/features/auth/data/models/register_dto.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';
import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/repositories/target_information_repository.dart';
import 'package:app/core/domain/usecases/base_use_case_with_param.dart';
import 'package:app/shared/constants/firebase_collection.dart';
import 'package:app/shared/utils/image_util.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';

class Register extends BaseUseCaseWithParam<RegisterDto, Member> {
  final AuthRepository _authRepository;
  final SequenceRepository _sequenceRepository;
  final MemberInformationRepository _memberInformationRepository;
  final TargetRepository _targetRepository;
  final TargetInformationRepository _targetInformationRepository;

  Register({
    required AuthRepository authRepository,
    required SequenceRepository sequenceRepository,
    required MemberInformationRepository memberInformationRepository,
    required TargetRepository targetRepository,
    required TargetInformationRepository targetInformationRepository,
  }) : _targetInformationRepository = targetInformationRepository,
       _targetRepository = targetRepository,
       _memberInformationRepository = memberInformationRepository,
       _sequenceRepository = sequenceRepository,
       _authRepository = authRepository;

  @override
  Future<Member> call(RegisterDto registerDto) async {
    bool isDuplicated = await _authRepository.existsByEmail(registerDto.email);
    if (isDuplicated) throw CustomException(ExceptionMessage.emailDuplicated);
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.memberCollection);
    var member = Member.fromDto(id, registerDto);

    var imagePath = ImageUtil.getProfileImagePath(id);
    var imageUploadResult = await ImageUtil.uploadDefaultImage(imagePath);

    await _authRepository.runTransaction((transaction) {
      _authRepository.create(member, transaction);
      var memberInformation = MemberInformation.fromId(member.id);
      _memberInformationRepository.create(memberInformation, transaction);
      var target = Target.defaultTarget(member.id, imageUploadResult);
      _targetRepository.create(target, transaction);
      var targetInformation = TargetInformation.defaultInformation(target.id, imageUploadResult);
      _targetInformationRepository.create(targetInformation, transaction);
    });

    return member;
  }
}
