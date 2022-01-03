import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';

import 'cell_widget.dart';

class MineSweeperCore extends StatefulWidget {
  final List<List<CellModel>> listCell;
  final int rowLenght;
  final int colLenght;
  final int numMines;
  final Difficulty difficulty;
  const MineSweeperCore(this.listCell, this.rowLenght, this.colLenght,
      this.numMines, this.difficulty,
      {Key? key})
      : super(key: key);
  @override
  _MineSweeperCore createState() => _MineSweeperCore();
}

class _MineSweeperCore extends State<MineSweeperCore> {
  // final double maxWidth = 400;
  @override
  Widget build(BuildContext context) {
    List<Widget> tmp = [];
    for (List<CellModel> list in widget.listCell) {
      for (var element in list) {
        var t = Padding(
            padding: const EdgeInsets.all(1), child: Cell(element, 20, 20));
        tmp.add(t);
      }
    }
    switch (widget.difficulty) {
      case Difficulty.easy:
        return InteractiveViewer(
          panEnabled: false,
          scaleEnabled: false,
          minScale: 1,
          maxScale: 4,
          //constrained: false,
          // boundaryMargin: const EdgeInsets.all(double.infinity),
          child: SizedBox(
            height: 600,
            width: 600,
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4.0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.colLenght),
                itemCount: tmp.length,
                addAutomaticKeepAlives: false,
                itemBuilder: (BuildContext context, int index) {
                  return tmp[index];
                },
              ),
            ),
          ),
        );
      case Difficulty.difficult:
      case Difficulty.medium:
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          constrained: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                // height: 600,
                // width: 600,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: getGrid(700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

//Create grid game
  Column getGrid(final double maxWidth) {
    List<Row> rows = [];
    for (int i = 0; i < widget.colLenght; i++) {
      rows.add(addRow(i, maxWidth));
    }
    return Column(
      children: rows,
    );
  }

//Add rows to the grid
  Row addRow(final int y, final double maxWidth) {
    List<Widget> list = [];
    for (int i = 0; i < widget.rowLenght; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Cell(widget.listCell[i][y], 40, 40),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
