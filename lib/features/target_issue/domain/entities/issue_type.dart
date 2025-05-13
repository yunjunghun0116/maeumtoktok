enum IssueType {
  positive("긍정", "positive"),
  negative("부정", "negative");

  final String name;
  final String type;

  const IssueType(this.name, this.type);
}
