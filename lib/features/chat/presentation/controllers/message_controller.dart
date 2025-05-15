import 'package:app/features/chat/data/models/read_more_message_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/usecases/create_message.dart';
import 'package:app/features/chat/domain/usecases/read_more_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/base_controller.dart';
import '../../domain/usecases/read_recent_message.dart';

class MessageController extends BaseController {
  final CreateMessage _createMessageUseCase;
  final ReadRecentMessage _readRecentMessageUseCase;
  final ReadMoreMessage _readMoreMessageUseCase;

  MessageController({
    required CreateMessage createMessageUseCase,
    required ReadRecentMessage readRecentMessageUseCase,
    required ReadMoreMessage readMoreMessageUseCase,
  }) : _readMoreMessageUseCase = readMoreMessageUseCase,
       _readRecentMessageUseCase = readRecentMessageUseCase,
       _createMessageUseCase = createMessageUseCase;

  Future<Message> create(Message message) async {
    return await callMethod<Message>(() => _createMessageUseCase.call(message));
  }

  Future<List<Message>> readMore(ReadMoreMessageDto readMoreMessageDto) async {
    return await callMethod<List<Message>>(() => _readMoreMessageUseCase.call(readMoreMessageDto));
  }

  Stream<QuerySnapshot> readAll(Chat chat) {
    return callStream<QuerySnapshot>(() => _readRecentMessageUseCase.call(chat));
  }
}
