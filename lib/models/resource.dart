abstract class Resource<T> {}

class Loading<T> extends Resource<T> {}

class Success<T> extends Resource<T> {
  final T data;
  Success(this.data);
}

class Error<T> extends Resource<T> {
  final String message;
  Error(this.message);
}
