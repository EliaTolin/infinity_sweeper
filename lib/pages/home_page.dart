import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/homepage_helper.dart';
import 'package:infinity_sweeper/models/ads/ad_banner_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/models/providers/purchase_provider.dart';
import 'package:infinity_sweeper/widgets/page_components/button/option_button_widget.dart';
import 'package:infinity_sweeper/widgets/page_components/topbar_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdBannerHelper adBannerHelper = AdBannerHelper();
  bool loadedBanner = false;
  bool proVersion = false;
  bool proVersionLoaded = false;
  void finishLoad(bool value) {
    setState(() {
      loadedBanner = value;
    });
  }

  void getProVersionAds() async {
    proVersion = await Provider.of<PurchaseProvider>(context, listen: false)
        .getProVersionAds();
    if (!proVersion) {
      adBannerHelper.createBannerAd(finishLoad);
    }
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProVersionAds();
  }

  @override
  void dispose() {
    super.dispose();
    adBannerHelper.adDispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      appBar: TopBar(size, "Infinity Sweeper"),
      backgroundColor: StyleConstant.mainColor,
      bottomNavigationBar: bottomBanner(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon.svg",
                  height: 150,
                  width: 150,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Easy",
                        () => openGame(context, Difficulty.easy),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Medium",
                        () => openGame(context, Difficulty.medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Difficult",
                        () => openGame(context, Difficulty.difficult),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Statistics",
                        () => Navigator.of(context)
                            .pushNamed(RouteConstant.statsRoute),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Purchase",
                        () => Navigator.of(context)
                            .pushNamed(RouteConstant.purchaseRoute),
                      ),
                    ),
                  ],
                ),
                const AutoSizeText("Develop by Tolin Elia",
                    style: TextStyle(color: StyleConstant.textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? bottomBanner() {
    
    if (proVersion) {
      return null;
    }
    if (loadedBanner) {
      // ignore: sized_box_for_whitespace
      return Container(
        height: adBannerHelper.getSizeBanner().height.toDouble(),
        width: adBannerHelper.getSizeBanner().width.toDouble(),
        child: AdWidget(
          ad: adBannerHelper.getBanner(),
        ),
      );
    } else {
      return Container(
        height: 50,
      );
    }
  }
}
