import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_services/games_services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/difficulty_helper.dart';
import 'package:infinity_sweeper/helpers/gameservices_helper.dart';
import 'package:infinity_sweeper/models/ads/ad_banner_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/purchase_provider.dart';
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
  GamesServicesHelper gamesServicesHelper = GamesServicesHelper();
  bool loadedBanner = false;
  int selectedIndex = 1;

  void finishLoad(bool value) {
    setState(() {
      loadedBanner = value;
    });
  }

  @override
  void initState() {
    super.initState();
    //intialize game services
    gamesServicesHelper.loadGamesService();
    //create bottom banner
    adBannerHelper.createBannerAd(finishLoad);
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.25, child: buildSelectGame()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
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
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        "Leaderboard",
                        () => GamesServices.showLeaderboards(
                            iOSLeaderboardID: 'easy_mode_leaderboard'),
                      ),
                    ),
                    const SizedBox(height: 15),
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

  Widget buildSelectGame() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: selectedIndex > 1
                    ? IconButton(
                        onPressed: () {
                          setState(() {});
                          selectedIndex > 1 ? selectedIndex-- : null;
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                      )
                    : Container(),
              ),
              Expanded(
                flex: 4,
                child: buildBodySelectElement(selectedIndex),
              ),
              Expanded(
                flex: 1,
                child: selectedIndex < 3
                    ? IconButton(
                        onPressed: () {
                          setState(() {});
                          selectedIndex < 3 ? selectedIndex++ : null;
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildBodySelectElement(int index) {
    Difficulty difficulty = getDifficultyFromIndex(index);
    return ClayContainer(
      borderRadius: 30,
      // depth: 40,
      // spread: 20,
      curveType: CurveType.concave,
      surfaceColor: StyleConstant.listColors[selectedIndex - 1],
      parentColor: StyleConstant.mainColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getDifficultyIcon(difficulty),
            AutoSizeText(
              getDifficultyBombString(difficulty) + " BOMBS",
              style: TextStyle(
                  fontSize: 25,
                  color: StyleConstant.listColors[index - 1].withAlpha(150),
                  fontWeight: FontWeight.bold),
            ),
            ClayText(
              getDifficultyString(difficulty),
              emboss: true,
              color: StyleConstant.listColors[index - 1],
              parentColor: StyleConstant.listColors[index - 1],
              textColor: StyleConstant.listColors[index - 1],
              style: TextStyle(
                color: StyleConstant.listColors[index - 1],
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
