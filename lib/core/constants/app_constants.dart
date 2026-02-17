class AppConstants {
  AppConstants._();

  // API
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Storage
  static const String userCacheKey = 'cached_user';
  static const String tokenKey = 'auth_token';
}
