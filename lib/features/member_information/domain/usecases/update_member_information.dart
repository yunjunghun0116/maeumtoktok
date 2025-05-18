import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';

import '../../../../core/domain/usecases/base_use_case_with_param.dart';

class UpdateMemberInformation extends BaseUseCaseWithParam<MemberInformation, MemberInformation> {
  final MemberInformationRepository _memberInformationRepository;

  UpdateMemberInformation({required MemberInformationRepository memberInformationRepository})
    : _memberInformationRepository = memberInformationRepository;

  @override
  Future<MemberInformation> execute(MemberInformation information) async {
    return await _memberInformationRepository.update(information);
  }
}
