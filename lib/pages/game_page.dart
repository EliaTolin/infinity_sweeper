import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gamepage_helper.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/models/providers/game_provider.dart';
import 'package:infinity_sweeper/models/providers/time_provider.dart';
import 'package:infinity_sweeper/widgets/game/minesweeper_widget.dart';
import 'package:infinity_sweeper/widgets/page_components/infobar_widget.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isBottomBannerAdLoaded = false;

  late BannerAd _bottomBanner;
  @override
  void deactivate() {
    super.deactivate();
    Provider.of<TimerProvider>(context, listen: false).resetTimer();
  }

  void createBannerAd() {
    _bottomBanner = BannerAd(
      adUnitId: AdConstant.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBanner.load();
  }

  void adDispose() {
    _bottomBanner.dispose();
    isBottomBannerAdLoaded = false;
  }

  @override
  void initState() {
    super.initState();
    createBannerAd();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<GameModelProvider>(context, listen: false).generateCellGrid();
      Provider.of<TimerProvider>(context, listen: false).startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    adDispose();
  }

  @override
  Widget build(BuildContext context) {
    //For android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: StyleConstant.mainColor,
      bottomNavigationBar: isBottomBannerAdLoaded
          ? Container(
              height: _bottomBanner.size.height.toDouble(),
              width: _bottomBanner.size.width.toDouble(),
              child: AdWidget(
                ad: _bottomBanner,
              ),
            )
          : Container(height: _bottomBanner.size.height.toDouble()),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InfoBar(size.height),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(StyleConstant.kPaddingComponent),
                child: ClayContainer(
                  borderRadius: 5,
                  curveType: CurveType.none,
                  surfaceColor: StyleConstant.mainColor,
                  parentColor: StyleConstant.mainColor,
                  color: StyleConstant.mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          height: constraints.maxHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Consumer<GameModelProvider>(
                              builder: (context, gameModel, child) {
                                //throw if cellGrid is null
                                CellGrid? cellGrid = gameModel.cellGrid;
                                if (cellGrid!.grid.isEmpty) {
                                  return Container();
                                }

                                if (gameModel.state == GameState.victory) {
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      computeWinGame(
                                          context, gameModel.difficulty);
                                    },
                                  );
                                }
                                if (gameModel.state == GameState.lose) {
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      computeLoseGame(context);
                                    },
                                  );
                                }
                                return MineSweeperCore(
                                    cellGrid.grid,
                                    cellGrid.sizeGrid,
                                    cellGrid.numMines,
                                    gameModel.difficulty);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
