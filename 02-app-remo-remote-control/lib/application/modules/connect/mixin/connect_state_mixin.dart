import 'dart:async';

import '../models/connect_state.dart';

mixin ConnectStateMixin {
  final StreamController<ConnectState> _stateController = StreamController.broadcast();
  ConnectState _state = ConnectStoppedState();

  Stream<ConnectState> get stateStream => _stateController.stream;
  ConnectState get state => _state;

  void setState(ConnectState newState) {
    _state = newState;
    _stateController.add(newState);
  }
}
