import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/core/controllers/minesweeper_controllers.dart';
import 'package:infinity_sweeper/core/controllers/game_logic_controller.dart';
import 'package:infinity_sweeper/core/providers/purchase_provider.dart';
import 'package:infinity_sweeper/core/providers/time_provider.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/ads/ad_interstitial_helper.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/ui/widgets/game/minesweeper_widget.dart';
import 'package:infinity_sweeper/ui/widgets/page_components/infobar_widget.dart';

import 'package:provider/provider.dart';

class MinesweeperPage extends StatefulWidget {
  const MinesweeperPage({Key? key}) : super(key: key);
  @override
  _MinesweeperPageState createState() => _MinesweeperPageState();
}

class _MinesweeperPageState extends State<MinesweeperPage> {
  AdInterstitialHelper adInterstitialHelper = AdInterstitialHelper();
  bool isProVersionAds = false;
  bool firstTap = true;
  final gameController = Get.find<GameLogicController>();
  final msController = Get.find<MinesweeperController>();

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<TimerProvider>(context, listen: false).stopTimer(notify: false);
    Provider.of<TimerProvider>(context, listen: false).resetTimer();
  }

  @override
  void dispose() {
    if (!isProVersionAds) {
      adInterstitialHelper.adDispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isProVersionAds =
        Provider.of<PurchaseProvider>(context, listen: false).isProVersionAds;
    if (!isProVersionAds) {
      adInterstitialHelper.createInterstialAd();
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      gameController.generateCellGrid();
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
                            child: buildMineSweeperWidget(),
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

  Widget buildMineSweeperWidget() {
    //throw if cellGrid is null
    MinesGrid cellGrid = gameController.cellGrid.value;
    if (cellGrid.gridCells.isEmpty) {
      return Container();
    }
    if (gameController.state == GameState.started && firstTap) {
      Provider.of<TimerProvider>(context, listen: false).startTimer();
      firstTap = false;
    }
    if (gameController.state == GameState.victory) {
      interstitialAd();
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          msController.computeWinGame(context, gameController.difficulty);
        },
      );
    }
    if (gameController.state == GameState.lose) {
      interstitialAd();
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          msController.computeLoseGame(context);
        },
      );
    }
    return MineSweeperWidget(cellGrid.gridCells, cellGrid.numRows,
        cellGrid.numColumns, cellGrid.numMines, gameController.difficulty);
  }

  void interstitialAd() async {
    if (isProVersionAds) {
      return;
    }
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    int timeAds = 0;
    if (await sharedPrefHelper.exist(AdConstant.dataTimeShowAds)) {
      timeAds = await sharedPrefHelper.read(AdConstant.dataTimeShowAds);
    }
    timeAds++;
    if (timeAds >= AdConstant.frequencyShowInterstialAd) {
      timeAds = 0;
      adInterstitialHelper.showInterstialAds();
    }
    sharedPrefHelper.save(AdConstant.dataTimeShowAds, timeAds);
  }
}
