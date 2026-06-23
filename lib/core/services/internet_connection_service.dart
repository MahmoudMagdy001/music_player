import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

enum NetworkState {
  connected,
  unstable,
  disconnected,
}

class InternetConnectionService {
  final Connectivity _connectivity = Connectivity();
  final BehaviorSubject<NetworkState> _networkStateController =
      BehaviorSubject<NetworkState>.seeded(NetworkState.connected);

  final PublishSubject<void> _connectivityRestoredController = PublishSubject<void>();

  Stream<NetworkState> get networkStateStream => _networkStateController.stream;
  NetworkState get currentNetworkState => _networkStateController.value;

  /// Emits whenever connection shifts from disconnected/unstable back to fully connected.
  Stream<void> get connectivityRestoredStream => _connectivityRestoredController.stream;

  InternetConnectionService() {
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    final previousState = _networkStateController.value;
    if (results.contains(ConnectivityResult.none)) {
      _networkStateController.add(NetworkState.disconnected);
    } else {
      _networkStateController.add(NetworkState.connected);
      if (previousState == NetworkState.disconnected) {
        _connectivityRestoredController.add(null);
      }
    }
  }

  /// Updates the latency network state based on response timings.
  /// Slow connection (latency > 2.8s for HTTP or > 450ms for Pings) marks it as unstable.
  void reportLatency(Duration duration) {
    if (_networkStateController.value == NetworkState.disconnected) return;

    if (duration.inMilliseconds > 2800) {
      _networkStateController.add(NetworkState.unstable);
    } else if (_networkStateController.value == NetworkState.unstable) {
      _networkStateController.add(NetworkState.connected);
    }
  }

  void dispose() {
    unawaited(_networkStateController.close());
    unawaited(_connectivityRestoredController.close());
  }
}
