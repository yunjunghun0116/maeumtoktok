enum ConversationStyleType {
  button("선택형", "button"),
  text("입력형", "text");

  final String name;
  final String type;

  const ConversationStyleType(this.name, this.type);
}
