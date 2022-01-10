import 'package:infinity_sweeper/constants/purchase_constant.dart';

class PurchaseModel {
  Map<String, dynamic> entitlementsPurchase = {
    PurchaseConstant.idProVersionEnt: false,
  };
  PurchaseModel();
  PurchaseModel.fromJson(Map<String, dynamic> json) {
    if (json['entitlements_purchase'] is Map<String, dynamic>) {
      entitlementsPurchase = json['entitlements_purchase'];
    }
  }

  Map<String, dynamic> toJson() => {
        'entitlements_purchase': entitlementsPurchase,
      };

  void addEntitlements(String value) {
    entitlementsPurchase[value] = true;
  }

  void removeEntitlements(String value) {
    entitlementsPurchase[value] = false;
  }

  bool isProVersionAds() {
    return entitlementsPurchase[PurchaseConstant.idProVersionEnt];
  }
}
