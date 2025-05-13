import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';

class UpdateMemberInformation implements BaseUseCaseWithParam<MemberInformation, MemberInformation> {
  final MemberInformationRepository memberInformationRepository;

  UpdateMemberInformation({required this.memberInformationRepository});

  @override
  Future<MemberInformation> call(MemberInformation information) async {
    return await memberInformationRepository.update(information);
  }
}
