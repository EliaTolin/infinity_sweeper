import 'dart:io';

class PurchaseConstant {
  static String get getApiKey {
    if (Platform.isAndroid) {
      return 'goog_gRSHovGtMgcmlTurIwAScjhNGVY';
    } else if (Platform.isIOS) {
      return 'appl_IxclWbdRQzOTrXUXvgStKiISyGx';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  //id of all entitlements
  static const idProVersionEnt = 'pro_version_ent';
  //list of all entitlements
  static const List<String> listPurchase = ['pro_version_ads'];
}
