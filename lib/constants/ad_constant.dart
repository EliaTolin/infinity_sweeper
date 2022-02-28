import 'dart:io';

import 'package:flutter/foundation.dart';

class AdConstant {
  static String get dataTimeShowAds => "time_show_ads";
  static int get frequencyShowInterstialAd => 5;
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          // for RELEASE
          : 'ca-app-pub-7500053685536877/4155873441';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/2934735716'
          // for RELEASE
          : 'ca-app-pub-7500053685536877/8740972986';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          // for RELEASE
          : 'ca-app-pub-7500053685536877/8382058914';
    } else if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/4411468910'
          // for RELEASE
          : 'ca-app-pub-7500053685536877/7472107433';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
