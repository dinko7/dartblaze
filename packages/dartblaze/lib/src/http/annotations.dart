import 'package:meta/meta_meta.dart';

@Target({TargetKind.function})
class Http {
  final bool auth;

  const Http({
    this.auth = true,
  });
}
