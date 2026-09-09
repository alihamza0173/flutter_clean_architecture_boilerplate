enum AppEnv { localhost, stage, production }

class Env {
  Env._();

  static const String _raw = String.fromEnvironment(
    'DART_ENV',
    defaultValue: 'localhost',
  );

  static AppEnv get current => switch (_raw) {
    'production' => AppEnv.production,
    'stage' => AppEnv.stage,
    _ => AppEnv.localhost,
  };

  static String get baseUrl => switch (current) {
    AppEnv.production => 'https://api.example.com',
    AppEnv.stage => 'https://stage-api.example.com',
    AppEnv.localhost => 'https://jsonplaceholder.typicode.com',
  };

  static bool get isProduction => current == AppEnv.production;
}
