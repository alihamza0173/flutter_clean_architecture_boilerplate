class ApiEndpoints {
  ApiEndpoints._();

  static const String posts = '/posts';

  static String post(int id) => '/posts/$id';
}
