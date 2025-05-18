import 'package:app/core/domain/usecases/base_use_case_with_param.dart';
import 'package:app/features/chat/data/models/read_more_message_dto.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';

class ReadMoreMessage extends BaseUseCaseWithParam<ReadMoreMessageDto, List<Message>> {
  final MessageRepository _messageRepository;

  ReadMoreMessage({required MessageRepository messageRepository}) : _messageRepository = messageRepository;

  @override
  Future<List<Message>> execute(ReadMoreMessageDto readMoreMessageDto) {
    return _messageRepository.loadMoreMessage(
      chat: readMoreMessageDto.chat,
      lastMessage: readMoreMessageDto.lastMessage,
    );
  }
}
