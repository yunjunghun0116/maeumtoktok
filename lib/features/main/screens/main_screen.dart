import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/chat/presentation/screens/chat_screen.dart';
import 'package:app/features/main/screens/home_screen.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/member/presentation/screens/member_screen.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target_issue/presentation/screens/issue_screen.dart';
import 'package:app/shared/utils/chat_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_overlay.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;

  var _isLoading = false;

  Widget getScreen() {
    Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = ChatScreen();
        break;
      case 2:
        screen = IssueScreen();
        break;
      default:
        screen = MemberScreen();
        break;
    }
    return SafeArea(child: screen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: getScreen(),
          bottomNavigationBar: Container(
            color: AppColors.whiteColor,
            child: SafeArea(
              child: Container(
                color: AppColors.whiteColor,
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    kBottomNavigationBarItem(
                      activeIcon: Icons.home,
                      inactiveIcon: Icons.home_outlined,
                      index: 0,
                      title: '홈',
                      onTap: () => setState(() => _currentIndex = 0),
                    ),
                    kBottomNavigationBarItem(
                      activeIcon: Icons.chat_bubble,
                      inactiveIcon: Icons.chat_bubble_outline,
                      index: 1,
                      title: '채팅',
                      onTap: () {
                        try {
                          if (_isLoading) return;
                          setState(() => _isLoading = true);

                          var member = context.read<MemberController>().member;
                          var target = context.read<TargetController>().target;
                          if (member == null) throw CustomException(ExceptionMessage.memberInformationRequired);
                          if (target == null) throw CustomException(ExceptionMessage.targetInformationRequired);

                          ChatUtil.goToChatScreen(member, target, context);
                        } on CustomException catch (e) {
                          rethrow;
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                    ),
                    kBottomNavigationBarItem(
                      activeIcon: Icons.view_list,
                      inactiveIcon: Icons.view_list_outlined,
                      index: 2,
                      title: '기억',
                      onTap: () => setState(() => _currentIndex = 2),
                    ),
                    kBottomNavigationBarItem(
                      activeIcon: Icons.person,
                      inactiveIcon: Icons.person_outlined,
                      index: 3,
                      title: '마이',
                      onTap: () => setState(() => _currentIndex = 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) LoadingOverlay(),
      ],
    );
  }

  Widget kBottomNavigationBarItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required int index,
    required String title,
    required Function() onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: AppColors.whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(_currentIndex == index ? activeIcon : inactiveIcon),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 12, height: 20 / 12, color: AppColors.fontGray600Color)),
            ],
          ),
        ),
      ),
    );
  }
}
