import 'package:app/core/exceptions/custom_exception.dart';
import 'package:app/core/exceptions/exception_message.dart';

enum SenderType {
  member,
  target;

  static const Map<String, SenderType> _enumMap = {"member": SenderType.member, "target": SenderType.target};

  static String getSenderTypeName(SenderType senderType) => senderType.name;

  static SenderType getSenderTypeFromName(String value) {
    if (!_enumMap.containsKey(value)) {
      throw CustomException(ExceptionMessage.badRequest);
    }
    return _enumMap[value]!;
  }
}
