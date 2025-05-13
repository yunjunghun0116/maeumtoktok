import 'package:app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:app/shared/constants/local_repository_key.dart';
import 'package:app/shared/repositories/local/local_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/app_colors.dart';
import '../controllers/member_controller.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemberController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "${controller.member?.name}님, 안녕하세요",
                    style: TextStyle(fontSize: 20, height: 1, color: AppColors.mainColor, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.read<LocalRepository>().delete(LocalRepositoryKey.isLoggedIn);
                      context.read<LocalRepository>().delete(LocalRepositoryKey.memberEmail);
                      controller.logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                        (route) => false,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "로그아웃",
                        style: TextStyle(fontSize: 14, height: 20 / 14, color: AppColors.fontGray800Color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            getCard(title: "문의하기", onTap: () {}),
          ],
        );
      },
    );
  }

  Widget getCard({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.subColor1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, height: 16 / 20, color: AppColors.subColor4, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
