import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../config/env.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio create({required FirebaseAuth firebaseAuth}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(firebaseAuth: firebaseAuth));
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }

    return dio;
  }
}
