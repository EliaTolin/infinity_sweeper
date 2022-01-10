import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';

class AdInterstitialHelper {
  static int maxFailedLoadAttemps = 3;
  int _interstialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;

  void createInterstialAd() {
    InterstitialAd.load(
      adUnitId: AdConstant.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstialLoadAttempts = 0;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _interstialLoadAttempts += 1;
          if (_interstialLoadAttempts >= maxFailedLoadAttemps) {
            createInterstialAd();
          }
        },
      ),
    );
  }

  void showInterstialAds() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  void adDispose() {
    _interstitialAd?.dispose();
  }
}
