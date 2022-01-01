import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';

class AdBannerProvider extends ChangeNotifier {
  bool isBottomBannerAdLoaded = false;

  late BannerAd _banner;

  void createBannerAd(Function fun) {
    _banner = BannerAd(
      adUnitId: AdConstant.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          fun();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _banner.load();
  }

  void adDispose() {
    _banner.dispose();
    isBottomBannerAdLoaded = false;
  }

  AdSize getSizeBanner() {
    return _banner.size;
  }

  BannerAd getBanner() {
    return _banner;
  }
}
