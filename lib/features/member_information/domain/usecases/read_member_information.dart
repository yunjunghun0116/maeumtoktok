import 'package:app/features/member_information/domain/repositories/target_information_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../entities/member_information.dart';

class ReadMemberInformation extends BaseUseCaseWithParam<String, MemberInformation> {
  final MemberInformationRepository _memberInformationRepository;

  ReadMemberInformation({required MemberInformationRepository memberInformationRepository})
    : _memberInformationRepository = memberInformationRepository;

  @override
  Future<MemberInformation> execute(String id) async {
    return await _memberInformationRepository.readById(id);
  }
}
