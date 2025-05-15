import 'package:app/core/domain/repositories/local_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/exceptions/custom_exception.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/sign_util.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/presentation/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  void _checkAutoLogin() async {
    await Future.delayed(Duration(seconds: 2), () async {
      if (!mounted) return;
      await context.read<LocalRepository>().initialize();
    });

    try {
      if (!mounted) return;
      var member = await context.read<AuthController>().autoLogin();
      if (!mounted) return;
      await SignUtil.login(context: context, member: member);
      return;
    } on CustomException catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: "logo",
            child: SizedBox(width: 200, height: 200, child: Image.asset("assets/logo/app_logo_no_background.png")),
          ),
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
