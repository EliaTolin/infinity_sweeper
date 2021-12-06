import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'dart:math';
import 'components/navigation_bar.dart';
import 'components/widget/minesweeper_widget.dart';

class GamePage extends StatefulWidget {
  final int sizeGrid;
  final int numMines;
  const GamePage(this.sizeGrid, this.numMines, {Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<CellModel>> listCell;
  @override
  void initState() {
    super.initState();
    listCell = generateCellGrid(widget.sizeGrid, widget.numMines);
  }

  @override
  Widget build(BuildContext context) {
    //it works with ios?
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink,
      bottomNavigationBar: const NavigationBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * StyleConstant.kHeighBarRatio,
            color: Colors.blue,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: double.infinity,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) =>
                            Center(
                      child: MineSweeperCore(
                          listCell, widget.sizeGrid, widget.numMines),
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

  List<List<CellModel>> generateCellGrid(
      final int sizeGrid, final int numMines) {
    List<List<CellModel>> cellGrid = [];

    for (int x = 0; x < sizeGrid; x++) {
      List<CellModel> row = [];
      for (int y = 0; y < sizeGrid; y++) {
        row.add(CellModel(x, y));
      }
      cellGrid.add(row);
    }

    addMines(cellGrid, numMines);
    addValueCell(cellGrid);

    return cellGrid;
  }

  void addMines(List<List<CellModel>> cellGrid, final int numMine) {
    final int length = cellGrid[0].length;
    final int maxLength = length * length;
    var numRandomList = [];

    for (int i = 0; i < numMine; i++) {
      int randomNumber = 0;
      do {
        randomNumber = Random().nextInt(maxLength);
      } while (numRandomList.contains(randomNumber));
      numRandomList.add(randomNumber);
      int x = randomNumber ~/ length;
      int y = (randomNumber % length).toInt();
      cellGrid[x][y].mine = true;
    }
  }

  void addValueCell(List<List<CellModel>> cellGrid) {
    final int length = cellGrid[0].length;
    for (int x = 0; x < length; x++) {
      for (int y = 0; y < length; y++) {
        CellModel cell = cellGrid[x][y];
        if (cell.isMine) {
          int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
          int endX = (cell.x + 1) > length - 1 ? length - 1 : cell.x + 1;

          int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
          int endY = (cell.y + 1) > length - 1 ? length - 1 : cell.y + 1;

          for (int j = startX; j <= endX; j++) {
            for (int k = startY; k <= endY; k++) {
              if (!cellGrid[j][k].isMine) {
                cellGrid[j][k].incValue();
              }
            }
          }
        }
      }
    }
  }
}
