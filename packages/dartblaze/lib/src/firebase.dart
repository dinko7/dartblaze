import 'package:dartblaze/src/environment.dart';
import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:dartblaze/src/http/firebase_auth_validator.dart';
import 'package:http/http.dart' as http;

FirebaseAdminApp? _adminApp;

Future<void> initialize() async {
  final projectId = await currentProjectId(
      platformWrapper: PlatformWrapper(), httpClient: http.Client());
  _adminApp = FirebaseAdminApp.initializeApp(
    projectId,
    Credential.fromApplicationDefaultCredentials(),
  );
}

Firestore get firestore => Firestore(_adminApp!);

Auth get auth => Auth(_adminApp!);

Messaging get messaging => Messaging(_adminApp!);
