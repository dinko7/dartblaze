/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

/// Core
export 'src/environment.dart';
export "src/firebase.dart";

/// Firestore
export "src/firestore/annotations.dart";
export "src/firestore/data.dart";
export "src/firestore/document_snapshot.dart";
export "src/firestore/firestore_path_parser.dart";

/// HTTP
export "src/http/annotations.dart";
export 'src/utils/request_body_accessor.dart';
export 'src/http/firebase_auth_validator.dart';
export 'package:openid_client/src/model.dart' show IdToken;
