import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/purchase_constant.dart';
import 'package:infinity_sweeper/helpers/logger_helper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseProvider extends ChangeNotifier {
  bool isProVersionAds = true;

  PurchaseProvider() {
    init();
    getUserPurchases();
    notifyListeners();
  }

  Future<bool> getIsActivePurchases(String idEnt) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      // access latest purchaserInfo
      if (purchaserInfo.entitlements.all.isEmpty) {
        return false;
      }
      if (purchaserInfo.entitlements.all[idEnt] != null &&
          purchaserInfo.entitlements.all[idEnt]!.isActive) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      LoggerHelper.print(e.message);
      return false;
    }
  }

  void getUserPurchases() async {
    isProVersionAds =
        await getIsActivePurchases(PurchaseConstant.idProVersionEnt);
  }

  Future init() async {
    try {
      Purchases.addPurchaserInfoUpdateListener((purchaseInfo) async {
        getUserPurchases();
        notifyListeners();
      });
    } on PlatformException catch (_) {}
  }

  Future<void> restorePurchase() async {
    try {
      await Purchases.restoreTransactions();
      getUserPurchases();
      notifyListeners();
    } on PlatformException catch (_) {
      // Error restoring purchases
    }
  }
}
