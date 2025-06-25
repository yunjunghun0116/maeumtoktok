import 'dart:async';

import 'package:app/core/logging/report/report_entity.dart';
import 'package:app/core/logging/report/report_logger.dart';
import 'package:app/core/logging/report/report_type.dart';
import 'package:app/features/chat/data/datasources/langchain_datasource.dart';
import 'package:app/features/chat/data/models/langchain_dto.dart';
import 'package:app/features/chat/data/models/read_chat_dto.dart';
import 'package:app/features/chat/data/models/read_more_message_dto.dart';
import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app/features/chat/presentation/controllers/message_controller.dart';
import 'package:app/features/chat/presentation/widgets/member_message_bubble.dart';
import 'package:app/features/chat/presentation/widgets/other_message_bubble.dart';
import 'package:app/features/chat/presentation/widgets/report_dialog.dart';
import 'package:app/features/chat/presentation/widgets/send_message_input.dart';
import 'package:app/features/member_information/domain/entities/member_information.dart';
import 'package:app/features/member_information/presentation/controllers/member_information_controller.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_information/domain/entities/target_information.dart';
import 'package:app/features/target_information/presentation/controllers/target_information_controller.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/features/target_issue/presentation/controllers/target_issue_controller.dart';
import 'package:app/shared/utils/chat_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/local_util.dart';
import '../../../member/presentation/controllers/member_controller.dart';
import '../../../target/domain/entities/target.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  StreamSubscription? _messageSubscription;

  bool _isLoading = false;
  bool _isScheduled = false;
  Chat? _chat;

  var _messages = <Message>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize();
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void initialize() async {
    var member = context.read<MemberController>().member!;
    var target = context.read<TargetController>().target!;
    var readChatDto = ReadChatDto(memberId: member.id, targetId: target.id);
    var result = await context.read<ChatController>().read(readChatDto);
    setState(() => _chat = result);
    messageInitialize();
  }

  void messageInitialize() {
    if (_chat == null) return;
    _messageSubscription = context.read<MessageController>().readAll(_chat!).listen((snapshot) {
      if (snapshot.docs.isEmpty) return;
      var result = snapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
      setState(() => _messages = result);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (result.isNotEmpty && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  void sendTargetMessage() async {
    if (_chat == null) return;
    if (!validateCanSendTargetMessage()) return;

    var member = context.read<MemberController>().member!;
    var memberInformation = context.read<MemberInformationController>().information!;
    var target = context.read<TargetController>().target!;
    var targetInformation = context.read<TargetInformationController>().information!;
    var positiveIssues = context.read<TargetIssueController>().positiveIssues;
    var negativeIssues = context.read<TargetIssueController>().negativeIssues;
    var normalIssues = context.read<TargetIssueController>().normalIssues;
    try {
      if (_isLoading) return;
      _isLoading = true;
      var langchainDto = await getLangChainDto(
        memberInfo: memberInformation,
        target: target,
        targetInfo: targetInformation,
        positiveIssues: positiveIssues,
        negativeIssues: negativeIssues,
        normalIssues: normalIssues,
        messages: _messages,
      );
      if (!mounted) return;

      if (langchainDto == null) return;
      var result = await context.read<LangchainDatasource>().nextTargetMessage(member.name, langchainDto);
      if (!mounted) return;
      var message = Message(
        chatId: _chat!.id,
        senderId: target.id,
        senderType: SenderType.target,
        contents: result,
        timeStamp: DateTime.now(),
      );
      await context.read<MessageController>().create(message);
    } catch (e) {
      rethrow;
    } finally {
      _isScheduled = false;
      _isLoading = false;
    }
  }

  bool validateCanSendTargetMessage() {
    if (_messages.isEmpty) return false;
    if (_messages.first.senderType == SenderType.target) return false;
    if (!validateMemberRecentMessage(_messages.first)) return false;
    return true;
  }

  bool validateMemberRecentMessage(Message recentMessage) {
    if (_isScheduled) return false;
    int needDelay = ChatUtil.calculateDelay(recentMessage.contents);
    int remainDelay = ChatUtil.calculateRemainDelay(recentMessage, needDelay);
    if (remainDelay <= 0) return true;
    _isScheduled = true;
    Future.delayed(Duration(seconds: remainDelay), () {
      setState(() => _isScheduled = false);
    });
    return false;
  }

  Future<LangchainDto?> getLangChainDto({
    required MemberInformation memberInfo,
    required Target target,
    required TargetInformation targetInfo,
    required List<TargetIssue> positiveIssues,
    required List<TargetIssue> negativeIssues,
    required List<TargetIssue> normalIssues,
    required List<Message> messages,
  }) async {
    var history = messages.reversed.toList();
    history.removeLast();

    var conversationsContext = await context.read<LangchainDatasource>().summarizeConversation(history);
    if (!mounted) return null;
    return LangchainDto(
      target: target,
      memberInformation: memberInfo,
      targetInformation: targetInfo,
      positiveIssues: positiveIssues,
      negativeIssues: negativeIssues,
      normalIssues: normalIssues,
      messages: history,
      conversationsContext: conversationsContext,
      message: messages.first.contents,
    );
  }

  Future<void> loadMoreMessage() async {
    if (_chat == null || _messages.isEmpty) return;
    var readMoreMessageDto = ReadMoreMessageDto(chat: _chat!, lastMessage: _messages.last);
    var moreMessages = await context.read<MessageController>().readMore(readMoreMessageDto);
    setState(() => _messages.addAll(moreMessages));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => sendTargetMessage());
    return Consumer2<MemberController, TargetController>(
      builder: (context, memberController, targetController, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            surfaceTintColor: AppColors.whiteColor,
            elevation: 0,
            leadingWidth: 48,
            leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                child: Icon(Icons.arrow_back_ios, size: 28),
              ),
            ),
            centerTitle: true,
            title: Text(
              targetController.target!.name,
              style: TextStyle(
                fontSize: 18,
                height: 28 / 18,
                letterSpacing: -0.5,
                color: AppColors.fontGray800Color,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  var result = await showDialog<ReportType?>(context: context, builder: (context) => ReportDialog());
                  if (result != null) {
                    var reportInformation = ReportEntity.of(memberId: memberController.member!.id, reportType: result);
                    await ReportLogger.report(reportInformation);
                    if (!context.mounted) return;
                    LocalUtil.showMessage(context, message: "신고 내용이 접수되었습니다.\n관리자 확인 후 조치 취하도록 하겠습니다.");
                  }
                },
                child: Icon(Icons.report_sharp, size: 24),
              ),
              SizedBox(width: 20),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_chat == null) {
                      return Center(child: CircularProgressIndicator(color: AppColors.mainColor));
                    }
                    return RefreshIndicator(
                      onRefresh: () async => await Future.delayed(Duration(milliseconds: 500), () => loadMoreMessage()),
                      color: AppColors.mainColor,
                      backgroundColor: AppColors.whiteColor,
                      child: ListView.builder(
                        itemCount: _messages.length,
                        controller: _scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (_messages[index].senderType == SenderType.member) {
                            return MemberMessageBubble(message: _messages[index]);
                          }
                          return OtherMessageBubble(message: _messages[index], target: targetController.target!);
                        },
                      ),
                    );
                  },
                ),
              ),
              SendMessageInput(chat: _chat),
            ],
          ),
        );
      },
    );
  }
}
