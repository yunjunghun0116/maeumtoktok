import 'package:app/features/chat/domain/entities/chat.dart';
import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/features/chat/presentation/controllers/message_controller.dart';
import 'package:app/features/member/domain/entities/member.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessageInput extends StatefulWidget {
  final Chat? chat;

  const SendMessageInput({super.key, required this.chat});

  @override
  State<SendMessageInput> createState() => _SendMessageInputState();
}

class _SendMessageInputState extends State<SendMessageInput> {
  final _messageController = TextEditingController();

  void _sendMessage(Member member, Target target) async {
    if (widget.chat == null) return;
    String text = _messageController.text;
    setState(() => _messageController.clear());
    if (text.isEmpty) return;

    var message = Message(
      chatId: widget.chat!.id,
      senderId: member.id,
      senderType: SenderType.member,
      contents: text,
      timeStamp: DateTime.now(),
    );
    await context.read<MessageController>().create(message);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MemberController, TargetController>(
      builder: (context, memberController, targetController, child) {
        var member = memberController.member!;
        var target = targetController.target!;
        return Container(
          color: AppColors.whiteColor,
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGray20Color),
                color: AppColors.darkGray10Color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.fontGray800Color,
                        height: 18 / 13,
                        letterSpacing: -0.5,
                      ),
                      maxLines: null,
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(minHeight: 42, maxHeight: 100),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (text) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _sendMessage(member, target),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _messageController.text.isNotEmpty ? AppColors.mainColor : AppColors.fontGray200Color,
                      ),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.send, color: AppColors.whiteColor, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
