import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/widgets/input_screen.dart';
import 'package:app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/common_text_field.dart';

class MemberInformationScreen extends StatefulWidget {
  const MemberInformationScreen({super.key});

  @override
  State<MemberInformationScreen> createState() => _MemberInformationScreenState();
}

class _MemberInformationScreenState extends State<MemberInformationScreen> {
  final _nameController = TextEditingController();

  var _isLoading = false;

  void _updateConversationStyle() async {
    try {
      var result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder:
              (inputScreenContext) => InputScreen(
                title: "내 말투나 대화 스타일",
                content: "상대방과 대화할 때 사용하는 \n나의 평소 말투나 대화 스타일을 \n자세하게 입력해 주세요.",
                hintText:
                    "퉁명스러운 말투, 차가운 말투, 장난스러운 말투, 친구스러운 대화, 시크하게, 유머러스하게, 조용히 공감하는 스타일, 고민을 많이 들어주는 스타일 등 상대방과 대화할 때의 내 말투나 대화 스타일을 자세하게 입력해 주세요. ",
                onTap: (String text) {
                  if (text.length < 20) {
                    throw CustomException(ExceptionMessage.needMoreConversationStyle);
                  }
                  Navigator.pop(inputScreenContext, text);
                },
                initialValue: context.read<MemberController>().member!.conversationStyle,
              ),
        ),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var controller = context.read<MemberController>();
      var member = controller.member!;
      member.updateConversationStyle(result);
      await context.read<MemberController>().update(member);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updatePersonality() async {
    try {
      var result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder:
              (inputScreenContext) => InputScreen(
                title: "내 성격",
                content: "상대방이 보았을 때, 나의 성격은 어떤것 같나요?\n내 성격을 입력해 주세요.",
                hintText:
                    "밝고 긍정적인 성격, 내성적이고 말이 적은 편, 감정을 잘 숨기지 않음, 주변을 잘 챙김, 단호하고 상대방을 신경쓰지 않음 등 내 성격이 잘 드러나도록 자세하게 입력해 주세요. ",
                onTap: (String text) {
                  if (text.length < 20) {
                    throw CustomException(ExceptionMessage.needMorePersonality);
                  }
                  Navigator.pop(inputScreenContext, text);
                },
                initialValue: context.read<MemberController>().member!.personality,
              ),
        ),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var controller = context.read<MemberController>();
      var member = controller.member!;
      member.updatePersonality(result);
      await context.read<MemberController>().update(member);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateName() async {
    try {
      setState(() => _isLoading = true);
      var controller = context.read<MemberController>();
      var member = controller.member!;
      member.updateName(_nameController.text);
      await context.read<MemberController>().update(member);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    var member = context.read<MemberController>().member!;
    _nameController.text = member.name;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberController>(
      builder: (context, controller, child) {
        var member = controller.member!;
        return Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  backgroundColor: AppColors.whiteColor,
                  elevation: 0,
                  leadingWidth: 48,
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_back_ios, size: 28),
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    "내 프로필",
                    style: TextStyle(
                      fontSize: 18,
                      height: 28 / 18,
                      letterSpacing: -0.5,
                      color: AppColors.fontGray800Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    updateContainer(
                      title: "이름",
                      hintText: "이름",
                      controller: _nameController,
                      onTap: () => _updateName(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 80, child: Text("성격", textAlign: TextAlign.center)),
                        Expanded(child: simpleActionButton("입력하기", () => _updatePersonality())),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 80, child: Text("말투 및 대화스타일", textAlign: TextAlign.center)),
                        Expanded(child: simpleActionButton("입력하기", () => _updateConversationStyle())),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading) LoadingOverlay(),
          ],
        );
      },
    );
  }

  Widget updateContainer({
    required String title,
    required TextEditingController controller,
    required Function() onTap,
    required String hintText,
    TextInputType inputType = TextInputType.text,
  }) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(title, textAlign: TextAlign.center)),
        Expanded(
          child: CommonTextField(
            controller: controller,
            hintText: hintText,
            onChanged: (String str) => setState(() {}),
            inputType: inputType,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.subColor1, borderRadius: BorderRadius.circular(10)),
            child: Text("변경", style: TextStyle(fontSize: 16, height: 20 / 16, color: AppColors.subColor4)),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Widget simpleActionButton(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.subColor1, borderRadius: BorderRadius.circular(10)),
        child: Text(title, style: TextStyle(fontSize: 16, height: 20 / 16, color: AppColors.subColor4)),
      ),
    );
  }
}
