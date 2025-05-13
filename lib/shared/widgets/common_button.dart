import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CommonButton extends StatelessWidget {
  final bool value;
  final Function onTap;
  final String title;

  const CommonButton({super.key, required this.value, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            color: value ? AppColors.mainColor : AppColors.fontGray100Color,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: value ? AppColors.whiteColor : AppColors.fontGray200Color,
              fontWeight: FontWeight.bold,
              height: 20 / 16,
            ),
          ),
        ),
      ),
    );
  }
}
