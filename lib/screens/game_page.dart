import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constant/route_constant.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game_model.dart';
import 'package:infinity_sweeper/models/gamestate_model.dart';
import 'package:infinity_sweeper/screens/components/info_bar.dart';
import 'components/custom_alert_dialog.dart';
import 'components/widget/minesweeper_widget.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<GameModel>(context, listen: false).generateCellGrid();
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
                            child: Consumer<GameModel>(
                              builder: (context, gameModel, child) {
                                //throw if cellGrid is null
                                CellGrid? cellGrid = Provider.of<GameModel>(
                                        context,
                                        listen: false)
                                    .cellGrid;
                                if (cellGrid!.grid.isEmpty) {
                                  return Container();
                                }
                                if (gameModel.state == GameState.victory) {
                                  WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) {
                                      showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (context) {
                                          return const CustomAlertDialog(
                                            title: "You win!",
                                            description:
                                                "Custom Popup dialog Description.",
                                            textButton1: "Home",
                                            textButton2: "Show grid",
                                            route: RouteConstant.homeRoute,
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                                if (gameModel.state == GameState.lose) {
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
