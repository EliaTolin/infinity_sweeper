import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/ads/purchase_model.dart';

class PurchaseProvider extends ChangeNotifier {
  Purchase purchase = Purchase();
  void setPurchase(bool value) {
    purchase.proVersion = value;
    notifyListeners();
  }
}
