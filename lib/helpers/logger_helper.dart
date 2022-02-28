import 'package:flutter/foundation.dart';

class LoggerHelper {
  static print(String? msg) {
    if (kDebugMode) {
      if (msg != null) print(msg);
    }
  }
}
