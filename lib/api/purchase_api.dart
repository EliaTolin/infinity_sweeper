import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/purchase_constant.dart';
import 'package:infinity_sweeper/helpers/logger_helper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  

  static Future init() async {
    if (kDebugMode) await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(PurchaseConstant.getApiKey);
    // await Purchases.setup(_getApiKey, appUserId: "18");
  }

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    try {
      final offers = await fetchOffers();
      return offers.where((offer) => ids.contains(offer.identifier)).toList();
    } on PlatformException catch (_) {
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
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo
          .entitlements.all[PurchaseConstant.idProVersionEnt]!.isActive) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      LoggerHelper.print(e.message);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        //showError(e);
      }
      return false;
    }
  }
}
