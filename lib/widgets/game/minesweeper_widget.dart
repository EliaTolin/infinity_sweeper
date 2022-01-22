import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';

import 'cell_widget.dart';

class MineSweeperWidget extends StatefulWidget {
  final List<List<CellModel>> listCell;
  final int numRows;
  final int numColumns;
  final int numMines;
  final Difficulty difficulty;
  const MineSweeperWidget(this.listCell, this.numRows, this.numColumns,
      this.numMines, this.difficulty,
      {Key? key})
      : super(key: key);
  @override
  _MineSweeperCore createState() => _MineSweeperCore();
}

class _MineSweeperCore extends State<MineSweeperWidget> {
  // final double maxWidth = 400;
  @override
  Widget build(BuildContext context) {
    List<Widget> tmp = [];
    for (List<CellModel> list in widget.listCell) {
      for (var element in list) {
        var t = Padding(
            padding: const EdgeInsets.all(1),
            child: CellWidget(element, 20, 20));
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
                    crossAxisCount: widget.numColumns),
                itemCount: tmp.length,
                addAutomaticKeepAlives: false,
                itemBuilder: (BuildContext context, int index) {
                  return tmp[index];
                },
              ),
            ),
          ),
        );
      case Difficulty.hard:
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
    for (int i = 0; i < widget.numColumns; i++) {
      rows.add(addRow(i, maxWidth));
    }
    return Column(
      children: rows,
    );
  }

//Add rows to the grid
  Row addRow(final int y, final double maxWidth) {
    List<Widget> list = [];
    for (int i = 0; i < widget.numRows; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: CellWidget(widget.listCell[i][y], 40, 40),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
