import 'package:app/features/chat/domain/entities/message.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OtherMessageBubble extends StatelessWidget {
  final Message message;
  final Target target;

  const OtherMessageBubble({super.key, required this.message, required this.target});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, right: 14),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.darkGray20Color,
              borderRadius: BorderRadius.circular(36),
              image: DecorationImage(image: NetworkImage(target.image), fit: BoxFit.cover),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: const EdgeInsets.only(left: 16, right: 20, top: 10, bottom: 10),
                constraints: const BoxConstraints(maxWidth: 208),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: AppColors.mainColor),
                ),
                child: Text(
                  message.contents,
                  style: TextStyle(fontSize: 13, height: 18 / 13, color: AppColors.fontGray600Color),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(
                  '${message.timeStamp.hour >= 12 ? '오후' : '오전'} ${message.timeStamp.hour > 12 ? message.timeStamp.hour - 12 : message.timeStamp.hour}:${message.timeStamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 10, height: 12 / 10, color: AppColors.fontGray500Color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
