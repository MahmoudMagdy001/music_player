import 'dart:async';

import 'package:dio/dio.dart';
import 'package:music_player/core/services/cancel_request_service.dart';
import 'package:music_player/core/services/internet_connection_service.dart';
import 'package:music_player/core/utils/task_runner.dart';

/// Interceptor that automatically registers a [CancelToken] for any Dio request
/// launched within a Safe Zone of a [SafeBloc] or [SafeCubit].
class CancelTokenInterceptor extends Interceptor {
  final CancelRequestService _cancelService;

  CancelTokenInterceptor(this._cancelService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Object? cancelKey = Zone.current[blocCancelKey];
    if (cancelKey != null) {
      final cancelToken = options.cancelToken ?? CancelToken();
      options.cancelToken = cancelToken;
      _cancelService.register(cancelKey, cancelToken);
    }
    super.onRequest(options, handler);
  }
}

/// Interceptor that measures latency for request round trips to determine the stability of the network.
class StabilityInterceptor extends Interceptor {
  final InternetConnectionService _internetService;
  final Map<RequestOptions, Stopwatch> _stopwatches = {};

  StabilityInterceptor(this._internetService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _stopwatches[options] = Stopwatch()..start();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final stopwatch = _stopwatches.remove(response.requestOptions);
    if (stopwatch != null) {
      stopwatch.stop();
      _internetService.reportLatency(stopwatch.elapsed);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final stopwatch = _stopwatches.remove(err.requestOptions);
    if (stopwatch != null) {
      stopwatch.stop();
      _internetService.reportLatency(stopwatch.elapsed);
    }
    super.onError(err, handler);
  }
}

/// Interceptor that attaches a Bearer authorization token.
class AuthInterceptor extends Interceptor {
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }
}

/// Unified network client wrapper utilizing Dio.
class DioService {
  final Dio _dio;
  final AuthInterceptor _authInterceptor;

  DioService(
    this._dio,
    CancelTokenInterceptor cancelInterceptor,
    StabilityInterceptor stabilityInterceptor,
    this._authInterceptor,
  ) {
    _dio.interceptors.addAll([
      _authInterceptor,
      cancelInterceptor,
      stabilityInterceptor,
    ]);
  }

  void setToken(String token) => _authInterceptor.setToken(token);
  void clearToken() => _authInterceptor.clearToken();

  FutureEither<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      runTask(
        () => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

  FutureEither<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      runTask(
        () => _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );
}
