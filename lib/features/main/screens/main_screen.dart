import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:app/features/chat/presentation/screens/chat_screen.dart';
import 'package:app/features/main/screens/home_screen.dart';
import 'package:app/features/member/presentation/screens/member_screen.dart';
import 'package:app/features/member/providers.dart';
import 'package:app/features/target/providers.dart';
import 'package:app/shared/utils/chat_util.dart';
import 'package:app/shared/utils/local_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/loading_overlay.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var _currentIndex = 0;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    validateAppState();
  }

  Future<void> validateAppState() async {
    try {
      setState(() => _isLoading = true);
      if (ref.read(memberControllerProvider).member == null || ref.read(targetControllerProvider).target == null) {
        LocalUtil.showMessage(context, message: "다시 로그인을 진행해 주세요.");
      }
    } catch (e) {
      await Future.delayed(
        Duration(seconds: 2),
        () =>
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SignInScreen()), (route) => false),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget getScreen() {
    Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = ChatScreen();
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

                          var member = ref.read(memberControllerProvider).member;
                          var target = ref.read(targetControllerProvider).target;
                          if (member == null || target == null) {
                            throw CustomException(ExceptionMessage.noObjectAssigned);
                          }

                          ChatUtil.goToChatScreen(context, ref: ref, member: member, target: target);
                        } on CustomException catch (e) {
                          rethrow;
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                    ),
                    kBottomNavigationBarItem(
                      activeIcon: Icons.settings,
                      inactiveIcon: Icons.settings_outlined,
                      index: 2,
                      title: '설정',
                      onTap: () => setState(() => _currentIndex = 2),
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
