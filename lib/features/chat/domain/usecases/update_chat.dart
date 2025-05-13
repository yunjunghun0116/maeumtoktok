import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class UpdateChat extends BaseUseCaseWithParam<Chat, Chat> {
  final ChatRepository chatRepository;

  UpdateChat({required this.chatRepository});

  @override
  Future<Chat> call(Chat chat) async {
    return await chatRepository.update(chat);
  }
}
