import 'package:app/features/auth/data/models/register_dto.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/domain/repositories/target_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';
import 'package:app/shared/utils/image_util.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';
import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';

class Register extends BaseUseCaseWithParam<RegisterDto, Member> {
  final AuthRepository _authRepository;
  final SequenceRepository _sequenceRepository;
  final TargetRepository _targetRepository;

  Register({
    required AuthRepository authRepository,
    required SequenceRepository sequenceRepository,
    required TargetRepository targetRepository,
  }) : _targetRepository = targetRepository,

       _sequenceRepository = sequenceRepository,
       _authRepository = authRepository;

  @override
  Future<Member> execute(RegisterDto registerDto) async {
    bool isDuplicated = await _authRepository.existsByEmail(registerDto.email);
    if (isDuplicated) throw CustomException(ExceptionMessage.emailDuplicated);
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.memberCollection);
    var member = Member.fromDto(id, registerDto);

    var imagePath = ImageUtil.getProfileImagePath(id);
    var imageUploadResult = await ImageUtil.uploadDefaultImage(imagePath);

    await _authRepository.runTransaction((transaction) {
      _authRepository.create(member, transaction);
      var target = Target.defaultTarget(member.id, imageUploadResult);
      _targetRepository.create(target, transaction);
    });

    return member;
  }
}
