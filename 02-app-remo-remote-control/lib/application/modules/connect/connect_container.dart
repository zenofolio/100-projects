import 'package:dlna_dart/dlna.dart';

typedef AdapterFactory<T, I> = T? Function(String id, I device);

class ConnectContainer<T, I> {
  final List<AdapterFactory<T, I>> _factories;

  const ConnectContainer([this._factories = const []]);

  /// Registers a factory that returns an adapter if it matches the device.
  void register(AdapterFactory<T, I> factory) {
    _factories.add(factory);
  }

  void setValue(List<AdapterFactory<T, I>> factories){
    _factories.clear();
    _factories.addAll(factories);
  }

  /// Tries to find a factory that can build a matching adapter.
  T? match(String id, I device) {
    for (final factory in _factories) {
      final adapter = factory(id, device);
      if (adapter != null) return adapter;
    }
    return null;
  }

  /// Unregisters a factory.
  void unregister(AdapterFactory<T,I> factory) {
    _factories.remove(factory);
  }


  List<AdapterFactory<T, I>> list(){
    return List.unmodifiable(_factories);
  }


}
