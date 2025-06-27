import 'package:app/core/domain/repositories/sequence_repository.dart';
import 'package:app/features/chat/data/models/create_chat_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';

import '../../../../core/base/base_use_case_with_param.dart';

class CreateChat extends BaseUseCaseWithParam<CreateChatDto, Chat> {
  final SequenceRepository _sequenceRepository;
  final ChatRepository _chatRepository;

  CreateChat({required SequenceRepository sequenceRepository, required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      _sequenceRepository = sequenceRepository;

  @override
  Future<Chat> execute(CreateChatDto createChatDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.chatCollection);
    var chat = Chat.of(id: id, member: createChatDto.member, target: createChatDto.target);
    await _chatRepository.create(chat);
    return chat;
  }
}
