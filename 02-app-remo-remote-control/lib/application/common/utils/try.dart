/// Represents the result of an operation that may succeed or fail.
sealed class TryResult<T> {
  const TryResult();

  /// Returns true if the result is a success.
  bool get isSuccess => this is TrySuccess<T>;

  /// Returns true if the result is an error.
  bool get isError => this is TryError<T>;

  /// Returns the value if it's a success, or throws if it's an error.
  T unwrap() => switch (this) {
    TrySuccess(value: final v) => v,
    TryError<T>() => throw Exception("Tried to unwrap a failed TryResult"),
  };

  /// Returns the error object if it's an error, or throws otherwise.
  Object unwrapError() => switch (this) {
    TryError(error: final e) => e,
    _ => throw Exception("No error in TryResult"),
  };
}

/// Represents a successful result.
final class TrySuccess<T> extends TryResult<T> {
  final T value;
  const TrySuccess(this.value);
}

/// Represents a failed result.
final class TryError<T> extends TryResult<T> {
  final Object error;
  final StackTrace? stackTrace;
  const TryError(this.error, [this.stackTrace]);
}

/// Executes an async function and returns a TryResult.
Future<TryResult<T>> tryAsync<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return TrySuccess(result);
  } catch (e, st) {
    return TryError(e, st);
  }
}

/// Extension on Future to convert it into a TryResult.
extension TryFuture<T> on Future<T> {
  Future<TryResult<T>> toTry() => tryAsync(() => this);
}

