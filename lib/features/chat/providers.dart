import 'package:app/core/base/base_controller.dart';
import 'package:app/core/providers.dart';
import 'package:app/features/chat/data/datasources/langchain_datasource.dart';
import 'package:app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:app/features/chat/data/repositories/message_repository_impl.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/features/chat/domain/repositories/message_repository.dart';
import 'package:app/features/chat/domain/usecases/create_chat.dart';
import 'package:app/features/chat/domain/usecases/create_message.dart';
import 'package:app/features/chat/domain/usecases/exists_chat.dart';
import 'package:app/features/chat/domain/usecases/read_chat.dart';
import 'package:app/features/chat/domain/usecases/read_more_message.dart';
import 'package:app/features/chat/domain/usecases/read_recent_message.dart';
import 'package:app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app/features/chat/presentation/controllers/message_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Repository Providers ---
final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepositoryImpl());
final messageRepositoryProvider = Provider<MessageRepository>((ref) => MessageRepositoryImpl());

// --- UseCases Providers ---
final createChatUseCaseProvider = Provider<CreateChat>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var chatRepository = ref.watch(chatRepositoryProvider);
  return CreateChat(sequenceRepository: sequenceRepository, chatRepository: chatRepository);
});

final existsChatUseCaseProvider = Provider<ExistsChat>((ref) {
  var chatRepository = ref.watch(chatRepositoryProvider);
  return ExistsChat(chatRepository: chatRepository);
});

final readChatUseCaseProvider = Provider<ReadChat>((ref) {
  var chatRepository = ref.watch(chatRepositoryProvider);
  return ReadChat(chatRepository: chatRepository);
});

final createMessageUseCaseProvider = Provider<CreateMessage>((ref) {
  var messageRepository = ref.watch(messageRepositoryProvider);
  return CreateMessage(messageRepository: messageRepository);
});

final readMoreMessageUseCaseProvider = Provider<ReadMoreMessage>((ref) {
  var messageRepository = ref.watch(messageRepositoryProvider);
  return ReadMoreMessage(messageRepository: messageRepository);
});

final readRecentMessageUseCaseProvider = Provider<ReadRecentMessage>((ref) {
  var messageRepository = ref.watch(messageRepositoryProvider);
  return ReadRecentMessage(messageRepository: messageRepository);
});

// --- Controller Providers ---
final chatControllerProvider = StateNotifierProvider<ChatController, BaseState>((ref) {
  var createChat = ref.watch(createChatUseCaseProvider);
  var existsChat = ref.watch(existsChatUseCaseProvider);
  var readChat = ref.watch(readChatUseCaseProvider);
  return ChatController(createChatUseCase: createChat, existsChatUseCase: existsChat, readChatUseCase: readChat);
});

final messageControllerProvider = StateNotifierProvider<MessageController, BaseState>((ref) {
  var createMessage = ref.watch(createMessageUseCaseProvider);
  var readMoreMessage = ref.watch(readMoreMessageUseCaseProvider);
  var readRecentMessage = ref.watch(readRecentMessageUseCaseProvider);
  return MessageController(
    createMessageUseCase: createMessage,
    readMoreMessageUseCase: readMoreMessage,
    readRecentMessageUseCase: readRecentMessage,
  );
});

// --- Resource Providers ---
final langchainDatasourceProvider = Provider<LangchainDatasource>((ref) => LangchainDatasource());
