import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/models/ads/entitlement.dart';
import 'package:infinity_sweeper/models/ads/purchase_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseProvider extends ChangeNotifier {
  Purchase purchase = Purchase();
  Entitlement _entitlements = Entitlement.free;
  Entitlement get entitlement => _entitlements;

  PurchaseProvider() {
    init();
  }
  void setPurchase(bool value) {
    purchase.proVersion = value;
    notifyListeners();
  }

  Future init() async {
    try {
      Purchases.addPurchaserInfoUpdateListener((purchaseInfo) async {
        updatePurchaseStatus();
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future updatePurchaseStatus() async {
    final purchaseInfo = await Purchases.getPurchaserInfo();
    print("ENTITLEMENT : " + purchaseInfo.entitlements.active.toString());
    final entitlements = purchaseInfo.entitlements.active.values.toList();
    _entitlements =
        entitlements.isEmpty ? Entitlement.free : Entitlement.REMOVE_ADS;
    notifyListeners();
  }
}
