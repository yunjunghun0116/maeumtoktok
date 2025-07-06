import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/features/target/presentation/widgets/target_additional_description_dialog.dart';
import 'package:app/features/target/presentation/widgets/target_conversation_style_dialog.dart';
import 'package:app/features/target/presentation/widgets/target_personality_dialog.dart';
import 'package:app/features/target_issue/presentation/screens/target_issue_screen.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/utils/image_util.dart';
import 'package:app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/common_text_field.dart';

class TargetInformationScreen extends StatefulWidget {
  const TargetInformationScreen({super.key});

  @override
  State<TargetInformationScreen> createState() => _TargetInformationScreenState();
}

class _TargetInformationScreenState extends State<TargetInformationScreen> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _personalityController = TextEditingController();
  final _conversationStyleController = TextEditingController();

  var _isLoading = false;

  void _updateAdditionalDescription() async {
    try {
      String? result = await showDialog<String?>(
        context: context,
        builder: (context) => TargetAdditionalDescriptionDialog(),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var controller = context.read<TargetController>();
      var target = controller.target!;
      target.updateAdditionalDescription(result);
      await controller.update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateConversationStyle() async {
    try {
      String? result = await showDialog<String?>(
        context: context,
        builder: (context) => TargetConversationStyleDialog(),
      );
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var controller = context.read<TargetController>();
      var target = controller.target!;
      target.updateConversationStyle(result);
      await controller.update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updatePersonality() async {
    try {
      String? result = await showDialog<String?>(context: context, builder: (context) => TargetPersonalityDialog());
      if (result == null) return;
      if (!mounted) return;
      setState(() => _isLoading = true);
      var controller = context.read<TargetController>();
      var target = controller.target!;
      target.updatePersonality(result);
      await controller.update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateImage(Target target) async {
    try {
      setState(() => _isLoading = true);
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      if (!mounted) return;
      var path = ImageUtil.getProfileImagePath(target.id);
      var result = await ImageUtil.uploadImage(image, path);
      if (!mounted) return;
      target.updateImage(result);
      await context.read<TargetController>().update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateName() async {
    try {
      setState(() => _isLoading = true);
      var controller = context.read<TargetController>();
      var target = controller.target!;
      target.updateName(_nameController.text);
      await context.read<TargetController>().update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateRelationship() async {
    try {
      setState(() => _isLoading = true);
      var controller = context.read<TargetController>();
      var target = controller.target!;
      target.updateRelationship(_relationshipController.text);
      await context.read<TargetController>().update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    var target = context.read<TargetController>().target!;
    _relationshipController.text = target.relationship;
    _personalityController.text = target.personality;
    _conversationStyleController.text = target.conversationStyle;
    _nameController.text = target.name;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TargetController>(
      builder: (context, controller, child) {
        var target = controller.target!;
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
                    "${target.name}의 프로필",
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
                    SizedBox(width: double.infinity),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.subColor4),
                        borderRadius: BorderRadius.circular(150),
                        image: DecorationImage(image: NetworkImage(target.image), fit: BoxFit.cover),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _updateImage(target),
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.fontGray50Color,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: AppColors.fontGray600Color),
                                ),
                                child: Icon(Icons.camera_alt, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    updateContainer(
                      title: "이름",
                      hintText: "이름",
                      controller: _nameController,
                      onTap: () => _updateName(),
                    ),
                    SizedBox(height: 20),
                    updateContainer(
                      title: "관계",
                      hintText: "사촌, 전 여자친구 등",
                      controller: _relationshipController,
                      onTap: () => _updateRelationship(),
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 80, child: Text("관련 기억", textAlign: TextAlign.center)),
                        Expanded(
                          child: simpleActionButton(
                            "입력하기",
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => TargetIssueScreen())),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 80, child: Text("추가 정보", textAlign: TextAlign.center)),
                        Expanded(child: simpleActionButton("입력하기", () => _updateAdditionalDescription())),
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
