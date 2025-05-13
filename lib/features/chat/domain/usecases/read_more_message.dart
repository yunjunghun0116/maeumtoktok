import 'package:app/features/chat/data/models/read_more_message_dto.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class ReadMoreMessage extends BaseUseCaseWithParam<ReadMoreMessageDto, List<Message>> {
  final MessageRepository _messageRepository;

  ReadMoreMessage({required MessageRepository messageRepository}) : _messageRepository = messageRepository;

  @override
  Future<List<Message>> call(ReadMoreMessageDto readMoreMessageDto) {
    return _messageRepository.loadMoreMessage(
      chat: readMoreMessageDto.chat,
      lastMessage: readMoreMessageDto.lastMessage,
    );
  }
}
