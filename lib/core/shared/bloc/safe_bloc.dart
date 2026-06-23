import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:music_player/core/services/cancel_request_service.dart';

/// Base class for all Blocs in the app. Ensures that:
/// 1. We don't emit states after the Bloc is closed.
/// 2. Active network requests spawned in this Bloc's context (Zone) are auto-cancelled on close.
abstract class SafeBloc<Event, State> extends Bloc<Event, State> {
  final Object _cancelKey = Object();

  SafeBloc(super.initialState);

  Object get cancelKey => _cancelKey;

  /// Runs the provided asynchronous action in a Safe Zone that stores the Bloc's cancel key.
  R runInSafeZone<R>(R Function() action) => runZoned(action, zoneValues: {blocCancelKey: _cancelKey});

  @override
  void on<E extends Event>(
    EventHandler<E, State> handler, {
    EventTransformer<E>? transformer,
  }) {
    super.on<E>(
      (event, emit) {
        final safeEmitter = _SafeEmitter<State>(emit, this);
        return runInSafeZone(() => handler(event, safeEmitter));
      },
      transformer: transformer,
    );
  }

  @override
  Future<void> close() async {
    try {
      if (GetIt.instance.isRegistered<CancelRequestService>()) {
        GetIt.instance<CancelRequestService>().cancelAll(_cancelKey);
      }
    } on Object catch (_) {}
    return super.close();
  }
}

/// A wrapper around [Emitter] that prevents emissions after the Bloc is closed.
class _SafeEmitter<State> implements Emitter<State> {
  final Emitter<State> _delegate;
  final BlocBase<State> _bloc;

  _SafeEmitter(this._delegate, this._bloc);

  @override
  void call(State state) {
    if (!_bloc.isClosed) {
      _delegate(state);
    }
  }

  @override
  bool get isDone => _delegate.isDone;

  @override
  Future<void> onEach<T>(
    Stream<T> stream, {
    required void Function(T data) onData,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    if (_bloc.isClosed) return Future.value();
    return _delegate.onEach(
      stream,
      onData: (data) {
        if (!_bloc.isClosed) onData(data);
      },
      onError: (error, stack) {
        if (!_bloc.isClosed) onError?.call(error, stack);
      },
    );
  }

  @override
  Future<void> forEach<T>(
    Stream<T> stream, {
    required State Function(T data) onData,
    State Function(Object error, StackTrace stackTrace)? onError,
  }) {
    if (_bloc.isClosed) return Future.value();
    return _delegate.forEach(
      stream,
      onData: (data) => onData(data),
      onError: (error, stack) => onError != null ? onError(error, stack) : _bloc.state,
    );
  }
}

/// Base class for all Cubits in the app. Ensures that:
/// 1. We don't emit states after the Cubit is closed.
/// 2. Active network requests spawned in this Cubit's context (Zone) are auto-cancelled on close.
abstract class SafeCubit<State> extends Cubit<State> {
  final Object _cancelKey = Object();

  SafeCubit(super.initialState);

  Object get cancelKey => _cancelKey;

  /// Runs the provided asynchronous action in a Safe Zone that stores the Cubit's cancel key.
  R runInSafeZone<R>(R Function() action) => runZoned(action, zoneValues: {blocCancelKey: _cancelKey});

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() async {
    try {
      if (GetIt.instance.isRegistered<CancelRequestService>()) {
        GetIt.instance<CancelRequestService>().cancelAll(_cancelKey);
      }
    } on Object catch (_) {}
    return super.close();
  }
}
