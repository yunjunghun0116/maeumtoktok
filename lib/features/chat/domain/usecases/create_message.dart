import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:app/core/domain/usecases/base_use_case_with_param.dart';

class CreateMessage extends BaseUseCaseWithParam<Message, Message> {
  final MessageRepository _messageRepository;

  CreateMessage({required MessageRepository messageRepository}) : _messageRepository = messageRepository;

  @override
  Future<Message> call(Message message) async {
    await _messageRepository.create(message);
    return message;
  }
}
