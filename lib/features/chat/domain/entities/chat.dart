import 'package:json_annotation/json_annotation.dart';

import '../../../member/domain/entities/member.dart';
import '../../../target/domain/entities/target.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String id;
  final String memberId;
  final String targetId;

  Chat({required this.id, required this.memberId, required this.targetId});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  factory Chat.of({required String id, required Member member, required Target target}) {
    return Chat(id: id, memberId: member.id, targetId: target.id);
  }

  @override
  String toString() {
    return 'Chat{id: $id, memberId: $memberId, targetId: $targetId}';
  }
}
