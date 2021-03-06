import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdBannerHelper adBannerHelper = AdBannerHelper();
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
            // left: 8,
            // right: 8,
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
                        AppLocalizations.of(context)!.statistics,
                        () => Navigator.of(context)
                            .pushNamed(RouteConstant.statsRoute),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        AppLocalizations.of(context)!.purchase,
                        () => Navigator.of(context)
                            .pushNamed(RouteConstant.purchaseRoute),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OptionButton(
                        AppLocalizations.of(context)!.leaderboard,
                        () => GamesServices.showLeaderboards(
                            iOSLeaderboardID: 'easy_mode_leaderboard'),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                AutoSizeText(
                    AppLocalizations.of(context)!.developBy + " Aurora Digital",
                    style: const TextStyle(color: StyleConstant.textColor)),
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
          child: CarouselSlider(
            options: CarouselOptions(
              height: constraints.maxHeight,
              enableInfiniteScroll: false,
              initialPage: 0,
            ),
            items: [1, 2, 3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        buildBodySelectElement(i, constraints.maxWidth * 0.75),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildBodySelectElement(int index, double sizeWidth) {
    Difficulty difficulty = getDifficultyFromIndex(index);
    return InkWell(
      onTap: () => openDifficultyGame(context, difficulty),
      child: ClayContainer(
        borderRadius: 30,
        depth: 35,
        spread: 10,
        width: sizeWidth,
        curveType: CurveType.concave,
        surfaceColor: StyleConstant.mainColor,
        parentColor: StyleConstant.listColorShadeDifficulty[index - 1],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getDifficultyGridSizeString(difficulty),
                  style: TextStyle(
                    fontFamily: 'Futura Round',
                    fontWeight: FontWeight.bold,
                    color: StyleConstant.listColors[index - 1],
                    fontSize: 60,
                  ),
                  maxLines: 1,
                ),
                Text(
                  getDifficultyBombString(difficulty) +
                      " " +
                      AppLocalizations.of(context)!.bombs.toUpperCase(),
                  style: TextStyle(
                    fontSize: 25,
                    color: StyleConstant.listColors[index - 1].withAlpha(150),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  getDifficultyString(difficulty, context),
                  style: TextStyle(
                    fontFamily: 'Futura Round',
                    color: StyleConstant.listColors[index - 1],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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
