import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';

enum SenderType {
  member("사용자", "member"),
  target("상대방", "target");

  final String name;
  final String type;

  const SenderType(this.name, this.type);

  static const Map<String, SenderType> _senderTypeMap = {"member": SenderType.member, "target": SenderType.target};

  static SenderType getType(String value) {
    if (!_senderTypeMap.containsKey(value)) {
      throw CustomException(ExceptionMessage.badRequest);
    }
    return _senderTypeMap[value]!;
  }
}
