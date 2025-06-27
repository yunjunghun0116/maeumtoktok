import 'package:app/features/chat/data/models/read_chat_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class ReadChat extends BaseUseCaseWithParam<ReadChatDto, Chat> {
  final ChatRepository _chatRepository;

  ReadChat({required ChatRepository chatRepository}) : _chatRepository = chatRepository;

  @override
  Future<Chat> execute(ReadChatDto readChatDto) async {
    return await _chatRepository.readByMemberIdAndTargetId(readChatDto.memberId, readChatDto.targetId);
  }
}
