class AppScope {
  static final Map<Type, dynamic> _services = {};

  static void register<T>(T instance) => _services[T] = instance;

  static T get<T>() {
    final service = _services[T];
    if (service == null) throw Exception('No service of type $T registered');
    return service as T;
  }

  static void unregister<T>() => _services.remove(T);
}
