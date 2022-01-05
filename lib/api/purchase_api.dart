import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static String get _getApiKey {
    if (Platform.isAndroid) {
      return 'goog_gRSHovGtMgcmlTurIwAScjhNGVY';
    } else if (Platform.isIOS) {
      return 'appl_IxclWbdRQzOTrXUXvgStKiISyGx';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_getApiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
