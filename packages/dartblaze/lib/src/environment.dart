import 'dart:io';
import 'package:http/http.dart' as http;

class Env {
  static String? _projectId;

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

  static String get projectId => _projectId!;

  static String _env(String key) {
    final value = Platform.environment[key];
    if (value == null) {
      throw ArgumentError('Environment variable $key is not set');
    }
    return value;
  }

  static Future<void> init() async {
    _projectId = await _gcpProjectId();
  }
}

enum Environment {
  local,
  production,
}

/// Returns the current Google Cloud Project ID.
/// Taken from: https://github.com/mtwichel/validate-firebase-auth-dart/blob/main/lib/src/validate_firebase_auth.dart
Future<String> _gcpProjectId() async {
  for (final envKey in _gcpProjectIdEnvironmentVariables) {
    final value = Platform.environment[envKey];
    if (value != null) return value;
  }

  const host = 'http://metadata.google.internal';
  final url = Uri.parse('$host/computeMetadata/v1/project/project-id');

  try {
    final response = await http.Client().get(
      url,
      headers: {'Metadata-Flavor': 'Google'},
    );

    if (response.statusCode != 200) {
      throw HttpException(
        '${response.body} (${response.statusCode})',
        uri: url,
      );
    }

    return response.body;
  } on SocketException {
    stderr.writeln(
      '''
Could not connect to $host.
If not running on Google Cloud, one of these environment variables must be set
to the target Google Project ID:
${_gcpProjectIdEnvironmentVariables.join('\n')}
''',
    );
    rethrow;
  }
}

final _gcpProjectIdEnvironmentVariables = {
  'GCP_PROJECT',
  'GCLOUD_PROJECT',
  'CLOUDSDK_CORE_PROJECT',
  'GOOGLE_CLOUD_PROJECT',
};
