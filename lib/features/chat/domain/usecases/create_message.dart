import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class CreateMessage extends BaseUseCaseWithParam<Message, Message> {
  final MessageRepository messageRepository;

  CreateMessage({required this.messageRepository});

  @override
  Future<Message> call(Message message) async {
    await messageRepository.create(message);
    return message;
  }
}
