import 'package:app/core/logging/log_entity.dart';

import '../../logging/logger.dart';

abstract class BaseUseCaseWithParam<Param, Result> {
  Future<Result> call(Param param) async {
    try {
      var functionName = runtimeType.toString();
      var result = await execute(param);
      var logEntity = LogEntity(input: param, output: result, functionName: functionName, timeStamp: DateTime.now());
      Logger.log(logEntity);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Result> execute(Param param);
}
