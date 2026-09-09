import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/logger.dart';

class AuthInterceptor extends Interceptor {
  final FirebaseAuth firebaseAuth;

  AuthInterceptor({required this.firebaseAuth});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await firebaseAuth.currentUser?.getIdToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      AppLogger.warning(
        'Failed to attach auth token: $e',
        tag: 'AuthInterceptor',
      );
    }
    handler.next(options);
  }
}
