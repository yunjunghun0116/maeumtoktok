import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';

class SigningScreen extends StatefulWidget {
  final Function registerFunction;

  const SigningScreen({super.key, required this.registerFunction});

  @override
  State<SigningScreen> createState() => _SigningScreenState();
}

class _SigningScreenState extends State<SigningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.registerFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 100),
          SizedBox(width: 200, height: 200, child: Image.asset("assets/logo/app_logo_no_background.png")),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: AppColors.subColor3, fontSize: 16, height: 20 / 16),
                children: [
                  TextSpan(
                    text: "마음톡톡\n\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainColor, height: 1),
                  ),
                  TextSpan(text: "안좋은 감정을 해결해주는\n"),
                  TextSpan(text: "나만의 부정감정 완화 에이전트"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
