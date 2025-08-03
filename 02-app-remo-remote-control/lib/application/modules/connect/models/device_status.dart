/// Simplified TV connection and control status
enum DeviceStatus {
  disconnected,
  connecting,
  connected,

  /// Optional: waiting for PIN or pairing input
  waitingForInput,

  /// Optional: trying to reconnect after losing connection
  reconnecting,

  error
}
