import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/domain/usecases/base_stream_use_case_with_param.dart';

class ReadRecentMessage extends BaseStreamUseCaseWithParam<Chat, QuerySnapshot> {
  final MessageRepository _messageRepository;

  ReadRecentMessage({required MessageRepository messageRepository}) : _messageRepository = messageRepository;

  @override
  Stream<QuerySnapshot> call(Chat chat) {
    return _messageRepository.readAllMessage(chat);
  }
}
