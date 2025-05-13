abstract class BaseUseCase<Result> {
  Future<Result> call();
}
