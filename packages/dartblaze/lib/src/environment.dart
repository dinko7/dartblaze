import 'dart:io';

class Env {
  static Environment get environment {
    final env = switch (_env('ENVIRONMENT')) {
      'local' => Environment.local,
      'production' => Environment.production,
      _ => null,
    };

    if (env == null) {
      return Environment.local;
    }

    return env;
  }

  static String get projectId => _env('PROJECT_ID');

  static String _env(String key) {
    final value = Platform.environment[key];
    if (value == null) {
      throw ArgumentError('Environment variable $key is not set');
    }
    return value;
  }
}

enum Environment {
  local,
  production,
}
