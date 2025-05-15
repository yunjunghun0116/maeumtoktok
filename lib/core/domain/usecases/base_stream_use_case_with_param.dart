abstract class BaseStreamUseCaseWithParam<Param, Result> {
  Stream<Result> call(Param param);
}
