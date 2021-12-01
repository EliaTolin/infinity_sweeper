import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'dart:math';

import 'components/navigation_bar.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<CellModel>> listCell = [];
  final int size = 30;
  final int numMine = 10;
  @override
  void initState() {
    super.initState();
    listCell = generateCellGrid(size, numMine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavigationBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Center(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: getGrid(constraints.maxWidth),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Create grid game
  Column getGrid(final double maxWidth) {
    List<Row> rows = [];

    for (int i = 0; i < size; i++) {
      rows.add(addRow(i, maxWidth));
    }

    return Column(
      children: rows,
    );
  }

  //Add rows to the grid
  Row addRow(final int y, final double maxWidth) {
    List<Widget> list = [];
    for (int i = 0; i < size; i++) {
      list.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClayContainer(
              width: maxWidth / size,
              height: maxWidth / size,
              color: StyleConstant.mainColor,
              surfaceColor: StyleConstant.mainColor,
              parentColor: StyleConstant.mainColor,
              child: Center(
                child: Text(listCell[y][i].isMine
                    ? "X"
                    : (listCell[y][i].value.toString())),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
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

  List<List<CellModel>> generateCellGrid(final int size, final int numMine) {
    List<List<CellModel>> cellGrid = [];

    for (int x = 0; x < size; x++) {
      List<CellModel> row = [];
      for (int y = 0; y < size; y++) {
        row.add(CellModel(x, y));
      }
      cellGrid.add(row);
    }

    addMines(cellGrid, numMine);
    addValueCell(cellGrid);

    return cellGrid;
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
