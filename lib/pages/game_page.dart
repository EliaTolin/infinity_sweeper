import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gamepage_helper.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'package:infinity_sweeper/widgets/game/minesweeper_widget.dart';
import 'package:infinity_sweeper/widgets/page_components/infobar_widget.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool firstTap = true;
  @override
  void deactivate() {
    super.deactivate();
    Provider.of<TimerProvider>(context, listen: false).resetTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<GameModelProvider>(context, listen: false).generateCellGrid();
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
}
