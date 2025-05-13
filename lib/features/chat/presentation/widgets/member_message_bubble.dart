import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MemberMessageBubble extends StatelessWidget {
  final Message message;

  const MemberMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Text(
              '${message.timeStamp.hour >= 12 ? '오후' : '오전'} ${message.timeStamp.hour > 12 ? message.timeStamp.hour - 12 : message.timeStamp.hour}:${message.timeStamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, height: 12 / 10, color: AppColors.fontGray500Color),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 20, right: 16, top: 10, bottom: 10),
            constraints: const BoxConstraints(maxWidth: 208),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(20),
              ),
              color: AppColors.mainColor,
            ),
            child: Text(
              message.contents,
              style: TextStyle(fontSize: 13, height: 18 / 13, color: AppColors.fontGray0Color),
            ),
          ),
        ],
      ),
    );
  }
}
