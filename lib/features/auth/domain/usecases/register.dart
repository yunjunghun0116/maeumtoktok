import 'package:app/features/auth/data/models/register_dto.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';
import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/domain/repositories/target_information_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';
import 'package:app/shared/constants/firebase_collection.dart';
import 'package:app/shared/utils/image_util.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/repositories/sequence/sequence_repository.dart';

class Register extends BaseUseCaseWithParam<RegisterDto, Member> {
  final AuthRepository authRepository;
  final SequenceRepository sequenceRepository;
  final MemberInformationRepository memberInformationRepository;
  final TargetRepository targetRepository;
  final TargetInformationRepository targetInformationRepository;

  Register({
    required this.authRepository,
    required this.sequenceRepository,
    required this.memberInformationRepository,
    required this.targetRepository,
    required this.targetInformationRepository,
  });

  @override
  Future<Member> call(RegisterDto registerDto) async {
    bool isDuplicated = await authRepository.existsByEmail(registerDto.email);
    if (isDuplicated) throw CustomException(ExceptionMessage.emailDuplicated);
    var id = await sequenceRepository.getNextSequence(FirebaseCollection.memberCollection);
    var member = Member.fromDto(id, registerDto);

    var imagePath = ImageUtil.getProfileImagePath(id);
    var imageUploadResult = await ImageUtil.uploadDefaultImage(imagePath);

    await authRepository.runTransaction((transaction) {
      authRepository.create(member, transaction);
      var memberInformation = MemberInformation.fromId(member.id);
      memberInformationRepository.create(memberInformation, transaction);
      var target = Target.defaultTarget(member.id, imageUploadResult);
      targetRepository.create(target, transaction);
      var targetInformation = TargetInformation.defaultInformation(target.id, imageUploadResult);
      targetInformationRepository.create(targetInformation, transaction);
    });

    return member;
  }
}
