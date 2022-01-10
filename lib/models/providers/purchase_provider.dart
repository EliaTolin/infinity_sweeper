import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/purchase_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/ads/purchase_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseProvider extends ChangeNotifier {
  PurchaseModel _purchaseModel = PurchaseModel();
  Map<String, dynamic> _entitlements = {};
  Map<String, dynamic> get entitlement => _entitlements;
  bool isInitiliazeData = false;
  SharedPrefHelper sharedPref = SharedPrefHelper();

  PurchaseProvider() {
    init();
    initializeData();
  }

  void initializeData() async {
    if (!await sharedPref.exist(PurchaseConstant.purchaseData)) {
      _purchaseModel = PurchaseModel();
      sharedPref.save(PurchaseConstant.purchaseData, _purchaseModel);
    } else {
      var data = await sharedPref.read(PurchaseConstant.purchaseData);
      _purchaseModel = PurchaseModel.fromJson(data);
    }
    isInitiliazeData = true;
  }

  void setPurchase(String value) {
    if (!isInitiliazeData) {
      initializeData();
    }
    _purchaseModel.addEntitlements(value);
    sharedPref.save(PurchaseConstant.purchaseData, _purchaseModel);
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
    final entitlements = purchaseInfo.entitlements.active.values.toList();
    for (var ent in entitlements) {
      if (ent.identifier == PurchaseConstant.idProVersionEnt) {
        setPurchase(PurchaseConstant.idProVersionEnt);
      }
    }
    notifyListeners();
  }

  bool isProVersionAds() {
    return _purchaseModel.isProVersionAds();
  }
}
