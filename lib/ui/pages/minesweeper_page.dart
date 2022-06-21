import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/ad_constant.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/ads/ad_interstitial_helper.dart';
import 'package:infinity_sweeper/helpers/game_logic/game_finish_helper.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/providers/purchase_provider.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'package:infinity_sweeper/ui/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:infinity_sweeper/ui/widgets/game/minesweeper_widget.dart';
import 'package:infinity_sweeper/ui/widgets/page_components/infobar_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinesweeperPage extends StatefulWidget {
  const MinesweeperPage({Key? key}) : super(key: key);
  @override
  _MinesweeperPageState createState() => _MinesweeperPageState();
}

class _MinesweeperPageState extends State<MinesweeperPage> {
  AdInterstitialHelper adInterstitialHelper = AdInterstitialHelper();
  bool isProVersionAds = false;
  bool firstTap = true;
  bool showedTutorial = false;
  bool gameTerminate = false;
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
    getTutorialShow();
    isProVersionAds =
        Provider.of<PurchaseProvider>(context, listen: false).isProVersionAds;
    if (!isProVersionAds) {
      adInterstitialHelper.createInterstialAd();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameModelProvider>(context, listen: false).generateCellGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                MinesGrid? cellGrid = gameModel.cellGrid;
                                if (cellGrid!.gridCells.isEmpty) {
                                  return Container();
                                }
                                if (gameModel.state == GameState.started &&
                                    firstTap) {
                                  Provider.of<TimerProvider>(context,
                                          listen: false)
                                      .startTimer();
                                  firstTap = false;
                                }
                                if (!gameTerminate &&
                                    gameModel.state == GameState.victory) {
                                  gameTerminate = true;
                                  interstitialAd();
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      computeWinGame(
                                          context, gameModel.difficulty);
                                    },
                                  );
                                }
                                if (!gameTerminate &&
                                    gameModel.state == GameState.lose) {
                                  gameTerminate = true;
                                  interstitialAd();
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      computeLoseGame(context);
                                    },
                                  );
                                }
                                return MineSweeperWidget(
                                    cellGrid.gridCells,
                                    cellGrid.numRows,
                                    cellGrid.numColumns,
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

  Future<void> getTutorialShow() async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    if (await sharedPrefHelper.exist(DataConstant.isShowedTutorial)) {
      showedTutorial =
          await sharedPrefHelper.read(DataConstant.isShowedTutorial);
    }
    if (!showedTutorial) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial1StartGameTitle,
              AppLocalizations.of(context)!.tutorial1StartGameDescr,
              AppLocalizations.of(context)!.next,
              "assets/icons_tutorial/cover_tile.png",
              () => Navigator.of(context).pop(),
            );
          });
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial2FindBombsTitle,
              AppLocalizations.of(context)!.tutorial2FindBombsDescr,
              AppLocalizations.of(context)!.next,
              "assets/icons_tutorial/flag_tile.png",
              () => Navigator.of(context).pop(),
            );
          });

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial3FlagsTitle,
              AppLocalizations.of(context)!.tutorial3FlagsDescr,
              AppLocalizations.of(context)!.next,
              "assets/icons_tutorial/flag.png",
              () => Navigator.of(context).pop(),
            );
          });

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial6DoubleClickTitle,
              AppLocalizations.of(context)!.tutorial6DoubleClickDescr,
              AppLocalizations.of(context)!.next,
              "assets/icons_tutorial/flags_double_click.png",
              () => Navigator.of(context).pop(),
            );
          });
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial4WinTitle,
              AppLocalizations.of(context)!.tutorial4WinDescr,
              AppLocalizations.of(context)!.next,
              "assets/icons/win.png",
              () => Navigator.of(context).pop(),
            );
          });
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              AppLocalizations.of(context)!.tutorial5WorldRankingTitle,
              AppLocalizations.of(context)!.tutorial5WorldRankingDescr,
              AppLocalizations.of(context)!.play,
              "assets/icons_tutorial/ranking.png",
              () => Navigator.of(context).pop(),
            );
          });
      sharedPrefHelper.save(DataConstant.isShowedTutorial, true);
    }
  }
}
