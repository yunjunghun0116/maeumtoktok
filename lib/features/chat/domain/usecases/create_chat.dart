import 'package:app/features/chat/data/models/create_chat_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';
import 'package:app/shared/constants/firebase_collection.dart';
import 'package:app/shared/repositories/sequence/sequence_repository.dart';

class CreateChat extends BaseUseCaseWithParam<CreateChatDto, Chat> {
  final SequenceRepository sequenceRepository;
  final ChatRepository chatRepository;

  CreateChat({required this.sequenceRepository, required this.chatRepository});

  @override
  Future<Chat> call(CreateChatDto createChatDto) async {
    var id = await sequenceRepository.getNextSequence(FirebaseCollection.chatCollection);
    var chat = Chat.of(id: id, member: createChatDto.member, target: createChatDto.target);
    await chatRepository.create(chat);
    return chat;
  }
}
