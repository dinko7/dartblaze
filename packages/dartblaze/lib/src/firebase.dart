import 'package:dartblaze/src/environment.dart';
import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_firebase_admin/messaging.dart';

FirebaseAdminApp? _adminApp;

void initializeAdminApp() {
  _adminApp = FirebaseAdminApp.initializeApp(
    Env.projectId,
    Credential.fromApplicationDefaultCredentials(),
  );
}

Firestore get firestore => Firestore(_adminApp!);

Auth get auth => Auth(_adminApp!);

Messaging get messaging => Messaging(_adminApp!);
