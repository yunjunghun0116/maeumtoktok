import '../../logging/log_entity.dart';
import '../../logging/logger.dart';

abstract class BaseUseCase<Result> {
  Future<Result> call() async {
    final functionName = runtimeType.toString();

    try {
      final result = await execute();
      var logEntity = LogEntity(
        memberId: null,
        input: null,
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

  Future<Result> execute();
}
