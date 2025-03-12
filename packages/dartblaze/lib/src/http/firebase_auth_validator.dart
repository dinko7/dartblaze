import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:openid_client/openid_client.dart';

// TODO: refactor this, I want the currentProjectId  to be private method inside firebase.dart and then validate only need the enviorment to get the proper variable names.
///
/// Taken from: https://github.com/mtwichel/validate-firebase-auth-dart/blob/main/lib/src/validate_firebase_auth.dart
/// {@template firebase_auth_validator}
/// An object to validate JWTs from Firebase Auth.
///
/// #### Usage
/// Validating is easy! Just
///
/// 1. Create a `FirebaseAuthValidator()`
/// 2. Initialize with `validator.init()`
/// 3. Validate JWT with `validator.validate()`
///
/// ```dart
/// final jwt = '...';  // Generated with a client library and sent with the request
/// final validator = FirebaseAuthValidator();
/// await validator.init();
/// final idToken = await validator.validate(jwt);
/// ```
/// {@endtemplate}
class FirebaseAuthValidator {
  /// {macro firebase_auth_emulator}
  FirebaseAuthValidator({
    PlatformWrapper? platformWrapper,
    @visibleForTesting http.Client? httpClient,
    @visibleForTesting Client? openIdClient,
  })  : _openIdClient = openIdClient,
        _platformWrapper = platformWrapper ?? PlatformWrapper(),
        _httpClient = httpClient ?? http.Client();

  final PlatformWrapper _platformWrapper;
  final http.Client _httpClient;

  Client? _openIdClient;

  /// Initializes authenticator and sets the project id.
  /// Must be called before `validate` is called.
  ///
  /// Example
  /// ```dart
  /// final validator = FirebaseAuthValidator();
  /// await validator.init();
  /// // ready to call validator.validate(token)
  /// ```
  ///
  /// The project id will be automatically discovered if running on a
  /// Google Cloud service like Cloud Run or GCE, but you can manually
  /// specify the project id like so:
  /// ```dart
  /// final validator = FirebaseAuthValidator();
  /// await validator.init(projectId: 'PROJECT-ID');
  /// // ready to call validator.validate(token)
  /// ```
  Future<void> init({String? projectId}) async {
    if (_openIdClient == null) {
      final calculatedProjectId = projectId ??
          await currentProjectId(
            platformWrapper: _platformWrapper,
            httpClient: _httpClient,
          );
      final issuer =
          await Issuer.discover(Issuer.firebase(calculatedProjectId));
      _openIdClient = Client(issuer, calculatedProjectId);
    }
  }

  /// Validates a given JWT from Firebase Auth.
  ///
  /// Example:
  /// ```dart
  /// final validator = FirebaseAuthValidator();
  /// await validator.init();
  /// final token = validator.validate(token)
  ///
  /// if (token.isVerified) {
  ///   // ... do authenticated stuff
  /// }
  /// ```
  Future<IdToken> validate(
    String token,
  ) async {
    final credential = _openIdClient!.createCredential(idToken: token);

    await for (final e in credential.validateToken()) {
      throw Exception('Validating ID token failed: $e');
    }

    if (!(credential.idToken.claims.subject.isNotEmpty &&
        credential.idToken.claims.subject.length <= 128)) {
      throw Exception(
        'ID token has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }
}

/// ONLY INTENDED FOR INTERNAL USE, MADE PUBLIC FOR TESTING
///
/// Returns the current project id if running on a Google Cloud service
/// like Cloud Run or GCE.
Future<String> currentProjectId({
  required PlatformWrapper platformWrapper,
  required http.Client httpClient,
}) async {
  for (final envKey in _gcpProjectIdEnvironmentVariables) {
    final value = platformWrapper.environment[envKey];
    if (value != null) return value;
  }

  const host = 'http://metadata.google.internal';
  final url = Uri.parse('$host/computeMetadata/v1/project/project-id');

  try {
    final response = await httpClient.get(
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

/// ONLY INTENDED FOR INTERNAL USE, MADE PUBLIC FOR TESTING
///
/// Wraps static Platform methods for mocking
@visibleForTesting
class PlatformWrapper {
  /// ONLY INTENDED FOR INTERNAL USE, MADE PUBLIC FOR TESTING
  ///
  /// Wraps static Platform.environment for testing
  @visibleForTesting
  Map<String, String> get environment => Platform.environment;
}
