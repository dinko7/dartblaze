class FirestorePathParser {
  FirestorePathParser(this.pathPattern) {
    _validatePattern(pathPattern);
  }

  final String pathPattern;

  Map<String, String> parse(String path) {
    final patternSegments = pathPattern.split('/');
    final pathSegments = path.replaceFirst('documents/', '').split('/');

    if (patternSegments.length != pathSegments.length) {
      throw ArgumentError('Path does not match the pattern');
    }

    final results = <String, String>{};

    for (var i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final pathSegment = pathSegments[i];

      if (patternSegment.startsWith('{') && patternSegment.endsWith('}')) {
        final key = patternSegment.substring(1, patternSegment.length - 1);
        results[key] = pathSegment;
      } else if (patternSegment != pathSegment) {
        throw ArgumentError('Path does not match the pattern');
      }
    }

    return results;
  }

  void _validatePattern(String pattern) {
    final segments = pattern.split('/');
    for (final segment in segments) {
      if (segment.startsWith('{') && !segment.endsWith('}')) {
        throw ArgumentError('Invalid pattern: Missing closing brace');
      } else if (!segment.startsWith('{') && segment.endsWith('}')) {
        throw ArgumentError('Invalid pattern: Missing opening brace');
      } else if (segment.startsWith('{') && segment.contains(' ')) {
        throw ArgumentError('Invalid pattern: Braces cannot contain spaces');
      }
    }
  }
}
