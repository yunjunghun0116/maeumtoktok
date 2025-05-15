class ExistsChatDto {
  final String memberId;
  final String targetId;

  ExistsChatDto({required this.memberId, required this.targetId});

  @override
  String toString() {
    return 'ExistsChatDto{memberId: $memberId, targetId: $targetId}';
  }
}
