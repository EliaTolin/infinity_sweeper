import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'package:infinity_sweeper/screens/components/widget/cell_widget.dart';

class MineSweeperCore extends StatefulWidget {
  final List<List<CellModel>> listCell;
  final int sizeGrid;
  final int numMines;
  const MineSweeperCore(this.listCell, this.sizeGrid, this.numMines, {Key? key})
      : super(key: key);
  @override
  _MineSweeperCore createState() => _MineSweeperCore();
}

class _MineSweeperCore extends State<MineSweeperCore> {
  //to do: parameters.
  final double maxWidth = 400;
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: getGrid(maxWidth),
            ),
          ),
        ],
      ),
    );
  }

//Create grid game
  Column getGrid(final double maxWidth) {
    List<Row> rows = [];

    for (int i = 0; i < widget.sizeGrid; i++) {
      rows.add(addRow(i, maxWidth));
    }

    return Column(
      children: rows,
    );
  }

//Add rows to the grid
  Row addRow(final int y, final double maxWidth) {
    List<Widget> list = [];
    for (int i = 0; i < widget.sizeGrid; i++) {
      list.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Cell(widget.listCell[i][y], maxWidth / widget.sizeGrid,
                maxWidth / widget.sizeGrid),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
