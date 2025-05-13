import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/sign_util.dart';
import '../../../member/domain/entities/gender.dart';
import '../../data/models/register_dto.dart';
import 'email_password_screen.dart';
import 'member_information_screen.dart';
import 'signing_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String _email;
  late String _password;
  late String _name;
  late int _age;
  var _gender = Gender.male;

  var _pageIndex = 0;

  void useEmailAndPassword(String email, String password) => setState(() {
    _email = email;
    _password = password;
    _pageIndex++;
  });

  void useMemberInformation(String name, Gender gender, int age) => setState(() {
    _name = name;
    _gender = gender;
    _age = age;
    _pageIndex++;
  });

  Future<void> register() async {
    var registerJson = {"email": _email, "password": _password, "name": _name, "age": _age, "gender": _gender.gender};
    var registerDto = RegisterDto.fromJson(registerJson);
    var member = await context.read<AuthController>().register(registerDto);
    if (!mounted) return;
    SignUtil.login(context: context, member: member, isSaveLocal: true);
  }

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return EmailPasswordScreen(onPressed: (String email, String password) => useEmailAndPassword(email, password));
      case 1:
        return MemberInformationScreen(
          onPressed: (String name, Gender gender, int age) => useMemberInformation(name, gender, age),
        );
      default:
        return SigningScreen(registerFunction: () => register());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.fontGray800Color,
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          leadingWidth: 48,
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_pageIndex > 0) {
                setState(() => _pageIndex--);
                return;
              }
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          actions: [
            ...[0, 1, 2].map(
              (index) =>
                  index == _pageIndex
                      ? Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.fontGray0Color,
                              fontWeight: FontWeight.bold,
                              height: 20 / 14,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      )
                      : Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.fontGray100Color,
                          ),
                        ),
                      ),
            ),
            const SizedBox(width: 20),
          ],
          elevation: 0,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(child: getScreen()),
      ),
    );
  }
}
