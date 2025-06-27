import 'package:app/features/chat/data/models/exists_chat_dto.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ExistsChat extends BaseUseCaseWithParam<ExistsChatDto, bool> {
  final ChatRepository _chatRepository;

  ExistsChat({required ChatRepository chatRepository}) : _chatRepository = chatRepository;

  @override
  Future<bool> execute(ExistsChatDto existsChatDto) async {
    return await _chatRepository.existsByMemberIdAndTargetId(existsChatDto.memberId, existsChatDto.targetId);
  }
}
