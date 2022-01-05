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

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    try {
      final offers = await fetchOffers();
      return offers.where((offer) => ids.contains(offer.identifier)).toList();
    } on PlatformException catch (e) {
      print(e.message);
      return [];
    }
  }

  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    try {
      final offerings = await Purchases.getOfferings();
      if (!all) {
        final current = offerings.current;
        return current == null ? [] : [current];
      } else {
        return offerings.all.values.toList();
      }
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      print(purchaserInfo.allPurchasedProductIdentifiers);
      print("entitlements " + purchaserInfo.entitlements.all.toString());
      return true;
    } catch (e) {
      return false;
    }
  }
}
