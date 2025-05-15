class ReadChatDto {
  final String memberId;
  final String targetId;

  ReadChatDto({required this.memberId, required this.targetId});

  @override
  String toString() {
    return 'ReadChatDto{memberId: $memberId, targetId: $targetId}';
  }
}
