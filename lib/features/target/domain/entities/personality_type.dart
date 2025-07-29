enum PersonalityType {
  button("선택형", "button"),
  text("입력형", "text");

  final String name;
  final String type;

  const PersonalityType(this.name, this.type);
}
