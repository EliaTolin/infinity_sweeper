import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gamepage_helper.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/ads/ad_interstitial_helper.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/models/providers/game_provider.dart';
import 'package:infinity_sweeper/models/providers/purchase_provider.dart';
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
  AdInterstitialHelper adInterstitialHelper = AdInterstitialHelper();

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<TimerProvider>(context, listen: false).resetTimer();
  }

  @override
  void dispose() {
    super.dispose();
    adInterstitialHelper.adDispose();
  }

  @override
  void initState() {
    super.initState();
    adInterstitialHelper.createInterstialAd();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<GameModelProvider>(context, listen: false).generateCellGrid();
      Provider.of<TimerProvider>(context, listen: false).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    //For android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: StyleConstant.mainColor,
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
                                  interstitialAd();
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      computeWinGame(
                                          context, gameModel.difficulty);
                                    },
                                  );
                                }
                                if (gameModel.state == GameState.lose) {
                                  interstitialAd();
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

  void interstitialAd() async {
    if (Provider.of<PurchaseProvider>(context, listen: false).proVersion) {
      return;
    }
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    int timeAds = 0;
    if (await sharedPrefHelper.exist(DataConstant.counterAdsTime)) {
      timeAds = await sharedPrefHelper.read(DataConstant.counterAdsTime);
    }
    timeAds++;
    if (timeAds >= AdConstant.frequencyShowInterstialAd) {
      timeAds = 0;
      adInterstitialHelper.showInterstialAds();
    }
    sharedPrefHelper.save(DataConstant.counterAdsTime, timeAds);
  }
}
