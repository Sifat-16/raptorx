abstract class UseCase<T, R> {
  Future<T> call({required R data});
}
