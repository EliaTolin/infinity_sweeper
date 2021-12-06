import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/cell_model.dart';

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
          "assets/icons/icons.svg",
          height: cellWidth,
          width: cellHeight,
        );
      }
      return Text(cell.value.toString());
    }
    if (cell.isFlaged) {
      return Icon(
        Icons.flag_outlined,
        size: cellHeight,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      width: cellWidth,
      height: cellHeight,
      color: StyleConstant.mainColor,
      surfaceColor: StyleConstant.mainColor,
      parentColor: StyleConstant.mainColor,
      child: Center(
        child: getContent(),
      ),
    );
  }
}
