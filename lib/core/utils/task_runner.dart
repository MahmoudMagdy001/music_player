import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/app_logger.dart';
import 'package:music_player/core/utils/failures.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Runs a task and wraps the result in an [Either].
/// Maps uncaught [DioException] to [NetworkFailure] or [ServerFailure],
/// and other exceptions to [LocalFailure].
FutureEither<T> runTask<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } on Object catch (e, stackTrace) {
    AppLogger.logError('Task failed: $e', e, stackTrace);
    if (e is Failure) {
      return Left(e);
    }
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure('Network timeout or connection error.'));
      }
      return Left(ServerFailure(e.response?.statusMessage ?? e.message ?? 'Server error.'));
    }
    return Left(LocalFailure(e.toString()));
  }
}
