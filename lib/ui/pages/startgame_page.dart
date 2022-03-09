import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/ads/ad_banner_helper.dart';
import 'package:infinity_sweeper/helpers/game_logic/difficulty_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/purchase_provider.dart';
import 'package:infinity_sweeper/ui/widgets/page_components/button/option_button_widget.dart';
import 'package:infinity_sweeper/ui/widgets/page_components/topbar_widget.dart';
import 'package:provider/provider.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({Key? key}) : super(key: key);

  @override
  State<StartGamePage> createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {
  AdBannerHelper adBannerHelper = AdBannerHelper();
  bool loadedBanner = false;

  void finishLoad(bool value) {
    setState(() {
      loadedBanner = value;
    });
  }

  @override
  void initState() {
    super.initState();
    //create bottom banner
    adBannerHelper.createBannerAd(finishLoad);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: TopBar(size, "Infinity Sweeper"),
        backgroundColor: StyleConstant.mainColor,
        bottomNavigationBar: Consumer<PurchaseProvider>(
          builder: (context, purchaseProvider, child) {
            if (purchaseProvider.isProVersionAds) {
              return Container(height: 1);
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
          },
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OptionButton(
                    "Easy",
                    () => openDifficultyGame(context, Difficulty.easy),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OptionButton(
                    "Medium",
                    () => openDifficultyGame(context, Difficulty.medium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OptionButton(
                    "Hard",
                    () => openDifficultyGame(context, Difficulty.hard),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OptionButton(
                    "Home",
                    () => Navigator.of(context)
                        .pushNamed(RouteConstant.homeRoute),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
