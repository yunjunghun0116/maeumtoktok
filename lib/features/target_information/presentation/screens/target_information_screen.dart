import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';
import 'package:app/features/target/domain/entities/target.dart';
import 'package:app/features/target/presentation/controllers/target_controller.dart';
import 'package:app/shared/constants/app_colors.dart';
import 'package:app/shared/constants/app_reg_exp.dart';
import 'package:app/shared/utils/image_util.dart';
import 'package:app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/common_text_field.dart';
import '../controllers/target_information_controller.dart';
import '../widgets/target_information_input_dialog.dart';

class TargetInformationScreen extends StatefulWidget {
  const TargetInformationScreen({super.key});

  @override
  State<TargetInformationScreen> createState() => _TargetInformationScreenState();
}

class _TargetInformationScreenState extends State<TargetInformationScreen> {
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _ageController = TextEditingController();

  var _isLoading = false;

  void _openTargetInformationDialog() async {
    var controller = context.read<TargetInformationController>();
    var information = controller.information!;
    String? result = await showDialog<String?>(
      context: context,
      builder: (context) => TargetInformationInputDialog(information: information),
    );
    if (result == null) return;
    if (!mounted) return;
    information.updateDescription(result);
    await controller.update(information);
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

  void _updateName(Target target) async {
    try {
      setState(() => _isLoading = true);
      target.updateName(_nameController.text);
      await context.read<TargetController>().update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateJob(Target target) async {
    try {
      setState(() => _isLoading = true);
      target.updateJob(_jobController.text);
      await context.read<TargetController>().update(target);
    } catch (e) {
      throw CustomException(ExceptionMessage.progressing);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateAge(Target target) async {
    if (_ageController.text.isEmpty || !AppRegExp.ageRegExp.hasMatch(_ageController.text)) {
      throw CustomException(ExceptionMessage.invalidType);
    }
    try {
      setState(() => _isLoading = true);
      target.updateAge(int.parse(_ageController.text));
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
    _nameController.text = context.read<TargetController>().target!.name;
    _jobController.text = context.read<TargetController>().target!.job;
    _ageController.text = context.read<TargetController>().target!.age.toString();
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
                    "상대방 프로필",
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
                        image: DecorationImage(image: NetworkImage(controller.target!.image), fit: BoxFit.cover),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _updateImage(controller.target!),
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
                    targetUpdateContainer(title: "이름", controller: _nameController, onTap: () => _updateName(target)),
                    SizedBox(height: 20),
                    targetUpdateContainer(title: "직업", controller: _jobController, onTap: () => _updateJob(target)),
                    SizedBox(height: 20),
                    targetUpdateContainer(
                      title: "나이",
                      controller: _ageController,
                      onTap: () => _updateAge(target),
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 80, child: Text("추가 정보", textAlign: TextAlign.center)),
                        Expanded(child: simpleActionButton("정보 입력하기", () => _openTargetInformationDialog())),
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

  Widget targetUpdateContainer({
    required String title,
    required TextEditingController controller,
    required Function() onTap,
    TextInputType inputType = TextInputType.text,
  }) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(title, textAlign: TextAlign.center)),
        Expanded(
          child: CommonTextField(
            controller: controller,
            hintText: title,
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
