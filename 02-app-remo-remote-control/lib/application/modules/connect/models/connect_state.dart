sealed class ConnectState {
  final Exception? error;
  final bool running;

  const ConnectState({this.error, required this.running});
}

class ConnectRunningState extends ConnectState {
  const ConnectRunningState() : super(running: true);
}

class ConnectStoppedState extends ConnectState {
  const ConnectStoppedState() : super(running: true);
}

class ConnectFailedState extends ConnectState {
  const ConnectFailedState({required Exception error})
    : super(error: error, running: false);
}
