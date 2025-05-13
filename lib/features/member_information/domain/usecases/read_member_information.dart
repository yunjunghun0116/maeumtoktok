import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';

import '../../../../shared/base/base_use_case_with_param.dart';
import '../entities/member_information.dart';

class ReadMemberInformation implements BaseUseCaseWithParam<String, MemberInformation> {
  final MemberInformationRepository memberInformationRepository;

  ReadMemberInformation({required this.memberInformationRepository});

  @override
  Future<MemberInformation> call(String id) async {
    return await memberInformationRepository.readById(id);
  }
}
