import '../../logging/log_entity.dart';
import '../../logging/logger.dart';

abstract class BaseUseCase<Result> {
  Future<Result> call() async {
    try {
      var functionName = runtimeType.toString();
      var result = await execute();
      var logEntity = LogEntity(input: null, output: result, functionName: functionName, timeStamp: DateTime.now());
      Logger.log(logEntity);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Result> execute();
}
