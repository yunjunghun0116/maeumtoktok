abstract class BaseUseCaseWithParam<Param, Result> {
  Future<Result> call(Param param);
}
