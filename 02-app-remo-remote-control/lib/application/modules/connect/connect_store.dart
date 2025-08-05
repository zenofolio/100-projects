import 'models/device_adapter.dart';

/// An abstract interface that defines how devices are stored, retrieved, and managed.
///
/// This allows you to implement different storage mechanisms (local, cloud, etc.)
/// without changing the rest of your application logic.
abstract class ConnectStore {
  /// Returns a list of all known devices.
  Future<List<DeviceAdapter>> getDevices();

  /// Returns a specific device by its [id], or `null` if not found.
  Future<DeviceAdapter?> getDevice(String id);

  /// Saves a single [device] to the store.
  Future<void> saveDevice(DeviceAdapter device);

  /// Saves multiple [devices] to the store at once.
  Future<void> saveDevices(List<DeviceAdapter> devices);

  /// Updates a specific [device] in the store.
  Future<void> updateDevice(DeviceAdapter device);

  /// Deletes the device with the given [id].
  Future<void> deleteDevice(String id);

  /// Clears all saved devices from the store.
  Future<void> clearDevices();


}
