import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/cellgrid_model.dart';
import 'package:infinity_sweeper/models/gamedata_model.dart';
import 'package:infinity_sweeper/models/providers/game_provider.dart';
import 'package:infinity_sweeper/models/gamestate_model.dart';
import 'package:infinity_sweeper/models/providers/time_provider.dart';
import 'package:infinity_sweeper/screens/components/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:infinity_sweeper/screens/components/widgets/alert_dialog/win_alert_dialog.dart';
import 'package:infinity_sweeper/screens/components/info_bar.dart';
import 'package:infinity_sweeper/screens/components/widgets/minesweeper_widget.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameData gameData = GameData();
  SharedPrefHelper sharedPref = SharedPrefHelper();

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<TimerProvider>(context, listen: false).resetTimer();
  }

  void loadData() async {
    gameData = GameData.fromJson(await sharedPref.read(DataConstant.data));
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
                                  bool record = false;
                                  int durationGame = int.parse(
                                      Provider.of<TimerProvider>(context,
                                              listen: false)
                                          .getString());
                                  Provider.of<TimerProvider>(context,
                                          listen: false)
                                      .stopTimer(notify: false);
                                  if (gameData.recordTimeInSecond >
                                      durationGame) {
                                    record = true;
                                    gameData.recordTimeInSecond = durationGame;
                                  }
                                  gameData.addWin();
                                  sharedPref.save(DataConstant.data, gameData);
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (context) {
                                          return WinAlertDialog(
                                            title: "You win!",
                                            textButton1: "Home",
                                            textButton2: "Show grid",
                                            route: RouteConstant.homeRoute,
                                            durationGame:
                                                durationGame.toString(),
                                            record: record,
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                                if (gameModel.state == GameState.lose) {
                                  Provider.of<TimerProvider>(context,
                                          listen: false)
                                      .stopTimer(notify: false);
                                  gameData.addLose();
                                  sharedPref.save(DataConstant.data, gameData);
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (context) {
                                          return const CustomAlertDialog(
                                            title: "You lose!",
                                            description:
                                                "When you lose, don't miss the lesson",
                                            textButton1: "Home",
                                            textButton2: "Show grid",
                                            route: RouteConstant.homeRoute,
                                          );
                                        },
                                      );
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
