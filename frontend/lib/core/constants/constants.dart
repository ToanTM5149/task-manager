import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Constants {
  static String get backendUri {
    const port = 8000;
    if (kIsWeb) {
      return "http://127.0.0.1:$port";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:$port";
    } else {
      return "http://localhost:$port";
    }
  }
}
