import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/repositories/target_conversation_style_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadAllTargetConversationStyle extends BaseUseCaseWithParam<String, List<TargetConversationStyle>> {
  final TargetConversationStyleRepository _targetConversationStyleRepository;

  ReadAllTargetConversationStyle({required TargetConversationStyleRepository targetConversationStyleRepository})
    : _targetConversationStyleRepository = targetConversationStyleRepository;

  @override
  Future<List<TargetConversationStyle>> execute(String id) async {
    return await _targetConversationStyleRepository.readAllByTargetId(id);
  }
}
