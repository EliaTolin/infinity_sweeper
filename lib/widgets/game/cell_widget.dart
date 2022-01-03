import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:provider/provider.dart';

class Cell extends StatelessWidget {
  final double cellWidth;
  final double cellHeight;
  final CellModel cell;
  const Cell(this.cell, this.cellWidth, this.cellHeight, {Key? key})
      : super(key: key);

  Widget getContent() {
    if (cell.isShowed) {
      if (cell.isMine) {
        return SvgPicture.asset(
          "assets/bomb.svg",
        );
      }
      if (cell.value == 0) return Container();
      return AutoSizeText(
        cell.value.toString(),
        style: TextStyle(
          color: StyleConstant.colorNumber[cell.value],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (cell.isFlagged) {
      return SvgPicture.asset(
        "assets/flag.svg",
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return XGestureDetector(
      longPressTimeConsider: 300,
      onTap: (_) {
        Provider.of<GameModelProvider>(context, listen: false)
            .computeCell(cell.x, cell.y);
      },
      onLongPress: (_) {
        Provider.of<GameModelProvider>(context, listen: false)
            .setFlag(cell.x, cell.y);
      },
      child: Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          color: cell.isShowed ? Colors.grey.shade300 : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: getContent(),
          ),
        ),
      ),
    );
  }
}
