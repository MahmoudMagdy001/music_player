import 'package:dio/dio.dart';

const Symbol blocCancelKey = Symbol('blocCancelKey');

class CancelRequestService {
  final Map<Object, List<CancelToken>> _tokens = {};

  void register(Object key, CancelToken token) {
    _tokens.putIfAbsent(key, () => []).add(token);
  }

  void cancelAll(Object key) {
    final list = _tokens.remove(key);
    if (list != null) {
      for (final token in list) {
        if (!token.isCancelled) {
          token.cancel('Cancelled due to Bloc/Cubit closing');
        }
      }
    }
  }
}
