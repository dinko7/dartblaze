import 'package:meta/meta.dart';
import 'package:openid_client/openid_client.dart';
import 'package:shelf/shelf.dart';

/// {@template firebase_auth_validator}
/// A validator for Firebase Auth JWTs, constructed via a factory with a project ID.
///
/// #### Usage
/// ```dart
/// final jwt = '...';  // Generated with a client library and sent with the request
/// final validator = await FirebaseAuthValidator.create(projectId: 'YOUR_PROJECT_ID');
/// final idToken = await validator.validate(jwt);
/// ```
/// {@endtemplate}
class FirebaseAuthValidator {
  // Private constructor
  FirebaseAuthValidator._({
    required this.projectId,
    required Client openIdClient,
  }) : _openIdClient = openIdClient;

  /// The project ID associated with this validator
  final String projectId;

  /// OpenID client used for validation
  final Client _openIdClient;

  /// Creates a new FirebaseAuthValidator with the specified project ID.
  ///
  /// Example:
  /// ```dart
  /// final validator = await FirebaseAuthValidator.create(projectId: 'YOUR_PROJECT_ID');
  /// ```
  ///
  /// The project ID must be provided explicitly.
  static Future<FirebaseAuthValidator> create({
    required String projectId,
    @visibleForTesting Client? openIdClient,
  }) async {
    if (projectId.isEmpty) {
      throw Exception('Project ID cannot be empty');
    }

    // Create OpenID client if not provided (mainly for testing)
    final oidcClient = openIdClient ?? await _createOpenIdClient(projectId);

    // Return new instance
    return FirebaseAuthValidator._(
      projectId: projectId,
      openIdClient: oidcClient,
    );
  }

  /// Helper method to create an OpenID client
  static Future<Client> _createOpenIdClient(String projectId) async {
    final issuer = await Issuer.discover(Issuer.firebase(projectId));
    return Client(issuer, projectId);
  }

  /// Validates a given JWT from Firebase Auth.
  ///
  /// Example:
  /// ```dart
  /// final token = await validator.validate(jwt);
  ///
  /// if (token.isVerified) {
  ///   // ... do authenticated stuff
  /// }
  /// ```
  Future<IdToken> validate(String token) async {
    final credential = _openIdClient.createCredential(idToken: token);

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

/// Extension on [Request] to add Firebase Auth validation capabilities
extension FirebaseAuthRequestExtension on Request {
  /// Authentication header name
  static const _authHeaderName = 'Authorization';

  /// Bearer prefix in auth header
  static const _bearerPrefix = 'Bearer ';

  /// Validates the request's Authorization header using Firebase Auth.
  ///
  /// If authentication is valid, executes the provided [onSuccess] callback.
  /// If authentication fails, returns a 403 Forbidden response.
  ///
  /// Example:
  /// ```dart
  /// Future<Response> handler(Request request) async {
  ///   return request.withFirebaseAuth(
  ///     projectId: 'my-project-id',
  ///     onSuccess: (idToken) {
  ///       final userId = idToken.claims.subject;
  ///       return Response.ok('Hello, user $userId!');
  ///     },
  ///   );
  /// }
  /// ```
  Future<Response> withFirebaseAuth({
    required String projectId,
    required Future<Response> Function(IdToken idToken) onAuthSuccess,
  }) async {
    // Get auth header
    final authHeader = headers[_authHeaderName];

    // Check if auth header exists and has correct format
    if (authHeader == null || !authHeader.startsWith(_bearerPrefix)) {
      return _unauthorizedResponse();
    }

    // Extract token
    final token = authHeader.substring(_bearerPrefix.length);

    try {
      // Create validator and validate token
      final validator =
          await FirebaseAuthValidator.create(projectId: projectId);
      final idToken = await validator.validate(token);

      // Call success handler with validated token
      return await onSuccess(idToken);
    } catch (e) {
      // Return forbidden on validation error
      return Response.forbidden('Invalid or expired token: ${e.toString()}');
    }
  }

  /// Creates an unauthorized response with WWW-Authenticate header
  Response _unauthorizedResponse() {
    return Response.unauthorized(
      'Authentication required',
      headers: {'WWW-Authenticate': 'Bearer'},
    );
  }
}
