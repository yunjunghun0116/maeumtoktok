import 'package:app/features/chat/data/models/read_chat_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class ReadChat extends BaseUseCaseWithParam<ReadChatDto, Chat> {
  final ChatRepository chatRepository;

  ReadChat({required this.chatRepository});

  @override
  Future<Chat> call(ReadChatDto readChatDto) async {
    return await chatRepository.readByMemberIdAndTargetId(readChatDto.memberId, readChatDto.targetId);
  }
}
