enum ReportType {
  profanity("profanity", "욕설 및 비속어"),
  misinformation("misinformation", "잘못된 정보"),
  personalInfo("personalInfo", "개인정보 노출"),
  etc("etc", "기타");

  final String name;
  final String title;

  const ReportType(this.name, this.title);
}
