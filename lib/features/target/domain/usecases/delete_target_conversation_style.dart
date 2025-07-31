import 'package:app/features/target/domain/repositories/target_conversation_style_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class DeleteTargetConversationStyle extends BaseUseCaseWithParam<String, void> {
  final TargetConversationStyleRepository _targetConversationStyleRepository;

  DeleteTargetConversationStyle({required TargetConversationStyleRepository targetConversationStyleRepository})
    : _targetConversationStyleRepository = targetConversationStyleRepository;

  @override
  Future<void> execute(String id) async {
    await _targetConversationStyleRepository.delete(id);
  }
}
