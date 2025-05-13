import 'package:flutter/material.dart';

import '../../../../core/exceptions/custom_exception.dart';
import '../../../../core/exceptions/exception_message.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_reg_exp.dart';
import '../../../../shared/widgets/common_button.dart';
import '../../../../shared/widgets/common_text_field.dart';
import '../../../member/domain/entities/gender.dart';

class MemberInformationScreen extends StatefulWidget {
  final Function onPressed;

  const MemberInformationScreen({super.key, required this.onPressed});

  @override
  State<MemberInformationScreen> createState() => _MemberInformationScreenState();
}

class _MemberInformationScreenState extends State<MemberInformationScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  var _gender = Gender.male;

  bool get _buttonValue => _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void nextPressed() {
    nameValidate();
    ageValidate();
    widget.onPressed(_nameController.text, _gender, int.parse(_ageController.text));
  }

  void nameValidate() {
    if (!AppRegExp.nameRegExp.hasMatch(_nameController.text)) {
      throw CustomException(ExceptionMessage.wrongNameRegExp);
    }
  }

  void ageValidate() {
    if (!AppRegExp.ageRegExp.hasMatch(_ageController.text)) {
      throw CustomException(ExceptionMessage.wrongAgeRegExp);
    }
    if (int.parse(_ageController.text) <= 0 || int.parse(_ageController.text) > 100) {
      throw CustomException(ExceptionMessage.wrongAgeRegExp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "가입 정보 입력",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.fontGray900Color,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "이름은 언제든 변경할 수 있어요.",
                        style: TextStyle(fontSize: 14, color: AppColors.fontGray500Color, height: 20 / 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 36),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text("이름", textAlign: TextAlign.center)),
                    Expanded(
                      child: CommonTextField(
                        controller: _nameController,
                        hintText: "이름",
                        onChanged: (String str) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text("나이", textAlign: TextAlign.center)),
                    Expanded(
                      child: CommonTextField(
                        controller: _ageController,
                        hintText: "나이",
                        inputType: TextInputType.number,
                        maxLength: 2,
                        onChanged: (String str) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text("성별", textAlign: TextAlign.center)),
                    SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        children: Gender.values.map((gender) => getGenderButton(gender, _gender == gender)).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CommonButton(value: _buttonValue, onTap: nextPressed, title: "다음"),
        SizedBox(height: 20),
      ],
    );
  }

  Widget getGenderButton(Gender gender, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        alignment: Alignment.center,
        width: 80,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: AppColors.mainColor) : null,
          color: isSelected ? AppColors.subColor1 : AppColors.fontGray50Color,
        ),
        child: Text(
          gender.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 20 / 14,
            color: isSelected ? AppColors.subColor4 : AppColors.fontGray400Color,
          ),
        ),
      ),
    );
  }
}
