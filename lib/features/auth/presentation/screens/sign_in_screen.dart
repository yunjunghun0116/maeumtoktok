import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/auth/data/models/login_dto.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/auth/presentation/widgets/invitation_dialog.dart';
import 'package:app/shared/widgets/common_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/sign_util.dart';
import '../../../../shared/widgets/common_button.dart';
import '../../../../shared/widgets/common_text_field.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAutoLogin = true;

  Future<void> loginWithEmailAndPassword() async {
    var loginDto = LoginDto(email: _emailController.text, password: _passwordController.text);
    var member = await context.read<AuthController>().login(loginDto);
    if (!mounted) return;
    SignUtil.login(context: context, member: member, isSaveLocal: _isAutoLogin);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Hero(
                tag: "logo",
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset("assets/logo/app_logo_no_background.png", fit: BoxFit.cover),
                ),
              ),
              CommonTextField(
                controller: _emailController,
                hintText: "이메일",
                inputType: TextInputType.emailAddress,
                onChanged: (String str) => setState(() {}),
              ),
              SizedBox(height: 20),
              CommonTextField(
                controller: _passwordController,
                hintText: "패스워드(8자 이상 영문 또는 숫자)",
                obscureText: true,
                onChanged: (String str) => setState(() {}),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => _isAutoLogin = !_isAutoLogin),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonCheckBox(
                        value: _isAutoLogin,
                        onTap: (value) => setState(() => _isAutoLogin = value),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '로그인 상태 유지',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.fontGray500Color,
                          height: 20 / 13,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CommonButton(value: true, onTap: loginWithEmailAndPassword, title: "로그인"),
              SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  String? result = await showDialog<String?>(
                    context: context,
                    builder: (context) => InvitationDialog(),
                  );
                  if (!mounted) return;
                  if (result == null) return;
                  if (result.isEmpty || result != "HCILAB") throw CustomException(ExceptionMessage.badRequest);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 120,
                  child: Text(
                    '회원가입',
                    style: TextStyle(fontSize: 14, color: AppColors.fontGray500Color, height: 20 / 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
