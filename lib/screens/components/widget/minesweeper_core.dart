import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';

class MineSweeperCore extends StatefulWidget {
  const MineSweeperCore({Key? key}) : super(key: key);
  @override
  _MineSweeperCore createState() => _MineSweeperCore();
}

class _MineSweeperCore extends State<MineSweeperCore> {
  //to do: parameters.
  final int size = 5;
  final double maxWidth = 400;
  List<List<CellModel>> listCell = [];
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
}
