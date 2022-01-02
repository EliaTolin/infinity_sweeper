import 'package:flutter/material.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _proVersion = false;
  bool get proVersion => _proVersion;
  set proVersion(bool value) => {_proVersion = value};
}
