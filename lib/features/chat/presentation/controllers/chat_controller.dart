import 'package:app/features/chat/data/models/create_chat_dto.dart';
import 'package:app/features/chat/data/models/exists_chat_dto.dart';
import 'package:app/features/chat/data/models/read_chat_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/usecases/create_chat.dart';
import 'package:app/features/chat/domain/usecases/exists_chat.dart';
import 'package:app/features/chat/domain/usecases/read_chat.dart';
import 'package:app/features/chat/domain/usecases/update_chat.dart';

import '../../../../../shared/base/base_controller.dart';

class ChatController extends BaseController {
  final CreateChat _createChatUseCase;
  final ExistsChat _existsChatUseCase;
  final ReadChat _readChatUseCase;
  final UpdateChat _updateChatUseCase;

  ChatController({
    required CreateChat createChatUseCase,
    required ExistsChat existsChatUseCase,
    required ReadChat readChatUseCase,
    required UpdateChat updateChatUseCase,
  }) : _updateChatUseCase = updateChatUseCase,
       _readChatUseCase = readChatUseCase,
       _existsChatUseCase = existsChatUseCase,
       _createChatUseCase = createChatUseCase;

  Future<Chat> create(CreateChatDto createChatDto) async {
    return await callMethod<Chat>(() => _createChatUseCase.call(createChatDto));
  }

  Future<bool> exists(ExistsChatDto existsChatDto) async {
    return await callMethod<bool>(() => _existsChatUseCase.call(existsChatDto));
  }

  Future<Chat> read(ReadChatDto readChatDto) async {
    return await callMethod<Chat>(() => _readChatUseCase.call(readChatDto));
  }

  Future<Chat> update(Chat chat) async {
    return await callMethod<Chat>(() => _updateChatUseCase.call(chat));
  }
}
