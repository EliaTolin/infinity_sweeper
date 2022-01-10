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
  late PurchaserInfo purchaserInfo;
  bool isProVersionAds = true;

  PurchaseProvider() {
    init();
    initializeData();
    getUserPurchases();
    notifyListeners();
  }

  void getUserPurchases() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      // access latest purchaserInfo
      if (purchaserInfo.entitlements.all.isEmpty) {
        isProVersionAds = false;
        return;
      }
      if (purchaserInfo.entitlements.all[PurchaseConstant.idProVersionEnt] !=
              null &&
          purchaserInfo
              .entitlements.all[PurchaseConstant.idProVersionEnt]!.isActive) {
        isProVersionAds = true;
      } else {
        isProVersionAds = false;
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
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
        getUserPurchases();
        notifyListeners();
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
