import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/domain/usecases/read_member_information.dart';
import 'package:app/features/member_information/domain/usecases/update_member_information.dart';

import '../../../../../shared/base/base_controller.dart';

class MemberInformationController extends BaseController {
  final ReadMemberInformation _readMemberInformationUseCase;
  final UpdateMemberInformation _updateMemberInformationUseCase;

  MemberInformationController({
    required ReadMemberInformation readMemberInformationUseCase,
    required UpdateMemberInformation updateMemberInformationUseCase,
  }) : _updateMemberInformationUseCase = updateMemberInformationUseCase,
       _readMemberInformationUseCase = readMemberInformationUseCase;

  MemberInformation? information;

  Future<void> initialize(Member member) async {
    information = await read(member.id);
    notifyListeners();
  }

  Future<MemberInformation> read(String id) async {
    return await callMethod<MemberInformation>(() => _readMemberInformationUseCase.call(id));
  }

  Future<void> update(MemberInformation information) async {
    await callMethod<MemberInformation>(() => _updateMemberInformationUseCase.call(information));
    this.information = information;
    notifyListeners();
  }
}
