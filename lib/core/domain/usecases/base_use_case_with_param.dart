import 'package:app/core/logging/log_entity.dart';

import '../../logging/logger.dart';

abstract class BaseUseCaseWithParam<Param, Result> {
  Future<Result> call(Param param) async {
    final functionName = runtimeType.toString();
    final memberId = _extractMemberId(param);

    try {
      final result = await execute(param);
      var logEntity = LogEntity(
        memberId: memberId,
        input: param,
        output: result,
        functionName: functionName,
        timeStamp: DateTime.now(),
      );
      await Logger.log(logEntity);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Result> execute(Param param);

  String? _extractMemberId(Param param) {
    try {
      if (param is Map && param.containsKey('memberId')) {
        return param['memberId']?.toString();
      }
      final dynamic dyn = param;
      return dyn.memberId?.toString();
    } catch (_) {
      return null;
    }
  }
}
