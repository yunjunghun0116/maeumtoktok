import 'package:app/core/domain/usecases/base_use_case_with_param.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';

class CreateMessage extends BaseUseCaseWithParam<Message, Message> {
  final MessageRepository _messageRepository;

  CreateMessage({required MessageRepository messageRepository}) : _messageRepository = messageRepository;

  @override
  Future<Message> execute(Message message) async {
    await _messageRepository.create(message);
    return message;
  }
}
