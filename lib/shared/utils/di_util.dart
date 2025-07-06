import 'package:app/core/data/repositories/local_repository_impl.dart';
import 'package:app/core/data/repositories/sequence_repository_impl.dart';
import 'package:app/core/domain/repositories/local_repository.dart';
import 'package:app/core/domain/repositories/sequence_repository.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/usecases/auto_login.dart';
import 'package:app/features/auth/domain/usecases/leave.dart';
import 'package:app/features/auth/domain/usecases/login.dart';
import 'package:app/features/auth/domain/usecases/register.dart';
import 'package:app/features/auth/domain/usecases/validate_unique_email.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
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
import 'package:app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app/features/chat/presentation/controllers/message_controller.dart';
import 'package:app/features/member/data/repositories/member_repository_impl.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/target/data/repositories/target_repository_impl.dart';
import 'package:app/features/target/domain/usecases/read_target.dart';
import 'package:app/features/target/domain/usecases/update_target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_issue/data/repositories/target_issue_repository_impl.dart';
import 'package:app/features/target_issue/domain/repositories/target_issue_repository.dart';
import 'package:app/features/target_issue/domain/usecases/create_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/delete_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/read_all_target_issue.dart';
import 'package:app/features/target_issue/domain/usecases/update_target_issue.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/chat/domain/usecases/read_recent_message.dart';
import '../../features/member/domain/repositories/member_repository.dart';
import '../../features/member/domain/usecases/update_member.dart';
import '../../features/target/domain/repositories/target_repository.dart';

final class DiUtil {
  static List<SingleChildWidget> dependencyInjection() {
    var result = <SingleChildWidget>[];
    result.addAll(_localDependency());
    result.addAll(_repositoryDependency());
    result.addAll(_authDependency());
    result.addAll(_memberDependency());
    result.addAll(_targetDependency());
    result.addAll(_targetIssueDependency());
    result.addAll(_chatDependency());
    result.addAll(_messageDependency());
    return result;
  }

  static List<SingleChildWidget> _repositoryDependency() {
    var result = <SingleChildWidget>[];
    result.add(Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()));
    result.add(Provider<MemberRepository>(create: (_) => MemberRepositoryImpl()));
    result.add(Provider<TargetRepository>(create: (_) => TargetRepositoryImpl()));
    result.add(Provider<TargetIssueRepository>(create: (_) => TargetIssueRepositoryImpl()));
    result.add(Provider<ChatRepository>(create: (_) => ChatRepositoryImpl()));
    result.add(Provider<MessageRepository>(create: (_) => MessageRepositoryImpl()));
    return result;
  }

  static List<SingleChildWidget> _localDependency() {
    var result = <SingleChildWidget>[];
    result.add(Provider<LocalRepository>(create: (_) => LocalRepositoryImpl()));
    result.add(Provider<SequenceRepository>(create: (_) => SequenceRepositoryImpl()));
    return result;
  }

  static List<SingleChildWidget> _authDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider2<AuthRepository, LocalRepository, AutoLogin>(
        update:
            (_, authRepository, localRepository, autoLogin) =>
                autoLogin ?? AutoLogin(authRepository: authRepository, localRepository: localRepository),
      ),
    );
    result.add(
      ProxyProvider<AuthRepository, Login>(
        update: (_, authRepository, login) => login ?? Login(authRepository: authRepository),
      ),
    );
    result.add(
      ProxyProvider3<AuthRepository, SequenceRepository, TargetRepository, Register>(
        update:
            (_, authRepository, sequenceRepository, targetRepository, register) =>
                register ??
                Register(
                  authRepository: authRepository,
                  sequenceRepository: sequenceRepository,
                  targetRepository: targetRepository,
                ),
      ),
    );
    result.add(
      ProxyProvider<AuthRepository, Leave>(
        update: (_, authRepository, leave) => leave ?? Leave(authRepository: authRepository),
      ),
    );
    result.add(
      ProxyProvider<AuthRepository, ValidateUniqueEmail>(
        update:
            (_, authRepository, validateUniqueEmail) =>
                validateUniqueEmail ?? ValidateUniqueEmail(authRepository: authRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider5<AutoLogin, Login, Register, ValidateUniqueEmail, Leave, AuthController?>(
        create: (_) => null,
        update:
            (_, autoLogin, login, register, validateUniqueEmail, leave, controller) =>
                controller ??
                AuthController(
                  autoLoginUseCase: autoLogin,
                  loginUseCase: login,
                  registerUseCase: register,
                  leaveUseCase: leave,
                  validateUniqueEmailUseCase: validateUniqueEmail,
                ),
      ),
    );
    return result;
  }

  static List<SingleChildWidget> _memberDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider<MemberRepository, UpdateMember>(
        update: (_, memberRepository, updateMember) => updateMember ?? UpdateMember(memberRepository: memberRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider<UpdateMember, MemberController?>(
        create: (_) => null,
        update: (_, updateMember, controller) => controller ?? MemberController(updateMemberUseCase: updateMember),
      ),
    );
    return result;
  }

  static List<SingleChildWidget> _targetDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider<TargetRepository, ReadTarget>(
        update: (_, targetRepository, readTarget) => readTarget ?? ReadTarget(targetRepository: targetRepository),
      ),
    );
    result.add(
      ProxyProvider<TargetRepository, UpdateTarget>(
        update: (_, targetRepository, updateTarget) => updateTarget ?? UpdateTarget(targetRepository: targetRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider2<ReadTarget, UpdateTarget, TargetController?>(
        create: (_) => null,
        update:
            (_, readTarget, updateTarget, controller) =>
                controller ?? TargetController(readTargetUseCase: readTarget, updateTargetUseCase: updateTarget),
      ),
    );

    return result;
  }

  static List<SingleChildWidget> _targetIssueDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider2<TargetIssueRepository, SequenceRepository, CreateTargetIssue>(
        update:
            (_, targetIssueRepository, sequenceRepository, createTargetIssue) =>
                createTargetIssue ??
                CreateTargetIssue(targetIssueRepository: targetIssueRepository, sequenceRepository: sequenceRepository),
      ),
    );
    result.add(
      ProxyProvider<TargetIssueRepository, ReadAllTargetIssue>(
        update:
            (_, targetIssueRepository, readAllTargetIssue) =>
                readAllTargetIssue ?? ReadAllTargetIssue(targetIssueRepository: targetIssueRepository),
      ),
    );
    result.add(
      ProxyProvider<TargetIssueRepository, UpdateTargetIssue>(
        update:
            (_, targetIssueRepository, updateTargetIssue) =>
                updateTargetIssue ?? UpdateTargetIssue(targetIssueRepository: targetIssueRepository),
      ),
    );
    result.add(
      ProxyProvider<TargetIssueRepository, DeleteTargetIssue>(
        update:
            (_, targetIssueRepository, deleteTargetIssue) =>
                deleteTargetIssue ?? DeleteTargetIssue(targetIssueRepository: targetIssueRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider4<
        CreateTargetIssue,
        ReadAllTargetIssue,
        UpdateTargetIssue,
        DeleteTargetIssue,
        TargetIssueController?
      >(
        create: (_) => null,
        update:
            (_, createTargetIssue, readAllTargetIssue, updateTargetIssue, deleteTargetIssue, controller) =>
                controller ??
                TargetIssueController(
                  createTargetIssueUseCase: createTargetIssue,
                  readAllTargetIssueUseCase: readAllTargetIssue,
                  updateTargetIssueUseCase: updateTargetIssue,
                  deleteTargetIssueUseCase: deleteTargetIssue,
                ),
      ),
    );
    return result;
  }

  static List<SingleChildWidget> _chatDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider2<ChatRepository, SequenceRepository, CreateChat>(
        update:
            (_, chatRepository, sequenceRepository, createChat) =>
                createChat ?? CreateChat(chatRepository: chatRepository, sequenceRepository: sequenceRepository),
      ),
    );
    result.add(
      ProxyProvider<ChatRepository, ExistsChat>(
        update: (_, chatRepository, existsChat) => existsChat ?? ExistsChat(chatRepository: chatRepository),
      ),
    );
    result.add(
      ProxyProvider<ChatRepository, ReadChat>(
        update: (_, chatRepository, readChat) => readChat ?? ReadChat(chatRepository: chatRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider3<CreateChat, ExistsChat, ReadChat, ChatController?>(
        create: (_) => null,
        update:
            (_, createChat, existsChat, readChat, controller) =>
                controller ??
                ChatController(createChatUseCase: createChat, existsChatUseCase: existsChat, readChatUseCase: readChat),
      ),
    );
    return result;
  }

  static List<SingleChildWidget> _messageDependency() {
    var result = <SingleChildWidget>[];
    result.add(
      ProxyProvider<MessageRepository, CreateMessage>(
        update:
            (_, messageRepository, createMessage) =>
                createMessage ?? CreateMessage(messageRepository: messageRepository),
      ),
    );
    result.add(
      ProxyProvider<MessageRepository, ReadRecentMessage>(
        update:
            (_, messageRepository, readAllMessage) =>
                readAllMessage ?? ReadRecentMessage(messageRepository: messageRepository),
      ),
    );
    result.add(
      ProxyProvider<MessageRepository, ReadMoreMessage>(
        update:
            (_, messageRepository, readMoreMessage) =>
                readMoreMessage ?? ReadMoreMessage(messageRepository: messageRepository),
      ),
    );
    result.add(
      ChangeNotifierProxyProvider3<CreateMessage, ReadRecentMessage, ReadMoreMessage, MessageController?>(
        create: (_) => null,
        update:
            (_, createMessage, readRecentMessage, readMoreMessage, controller) =>
                controller ??
                MessageController(
                  createMessageUseCase: createMessage,
                  readRecentMessageUseCase: readRecentMessage,
                  readMoreMessageUseCase: readMoreMessage,
                ),
      ),
    );

    result.add(Provider<LangchainDatasource>(create: (_) => LangchainDatasource()));
    return result;
  }
}
