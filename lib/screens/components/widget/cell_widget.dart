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
    // return Container(
    //   width: cellWidth,
    //   height: cellHeight,
    //   decoration: BoxDecoration(
    //     // border: Border.all(
    //     //   //color: Color(0xFFF05A22),
    //     //   style: BorderStyle.solid,
    //     //   width: 1.0,
    //     // ),
    //     color: Colors.grey.shade300,
    //     borderRadius: BorderRadius.circular(5.0),
    //   ),
    //   // surfacecolor: styleconstant.maincolor,
    //   // parentcolor: styleconstant.maincolor,
    //   child: Center(
    //     child: getContent(),
    //   ),
    // );
    return ClayContainer(
      width: cellWidth,
      height: cellHeight,
      borderRadius: 5,
      color: Colors.grey.shade300,
      // surfaceColor: Colors.grey.shade300,
      // surfaceColor: Colors.grey.shade300,
      surfaceColor: StyleConstant.mainColor,
      parentColor: StyleConstant.mainColor,
      curveType: CurveType.concave,
      child: Center(
        child: getContent(),
      ),
    );
  }
}
