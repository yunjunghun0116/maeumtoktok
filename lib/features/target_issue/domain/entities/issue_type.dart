import 'package:app/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum IssueType {
  positive("긍정", "positive"),
  negative("부정", "negative"),
  normal("중립", "normal");

  final String name;
  final String type;

  const IssueType(this.name, this.type);

  static Map<IssueType, Color> _colorMap = {
    IssueType.positive: AppColors.okColor,
    IssueType.negative: AppColors.noColor,
    IssueType.normal: AppColors.fontGray600Color,
  };

  Color get color => _colorMap[this]!;
}
