import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'package:infinity_sweeper/models/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game_model.dart';
import 'package:infinity_sweeper/screens/components/navigation_bar.dart';
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
    Provider.of<GameModel>(context, listen: false).generateCellGrid();
  }

  @override
  Widget build(BuildContext context) {
    //For android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: StyleConstant.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NavigationBar(size.height),
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
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   //color: Color(0xFFF05A22),
                      //   style: BorderStyle.solid,
                      //   width: 1.0,
                      // ),
                      //color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) =>
                              Center(
                        child: Consumer<GameModel>(
                          builder: (context, gameModel, child) {
                            //throw if cellGrid is null
                            List<List<CellModel>> listCell = [];
                            CellGrid? cellGrid =
                                Provider.of<GameModel>(context, listen: false)
                                    .cellGrid;
                            return MineSweeperCore(listCell, cellGrid!.sizeGrid,
                                cellGrid.numMines);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
