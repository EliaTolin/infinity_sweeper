import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'package:infinity_sweeper/models/game_model.dart';
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
          "assets/icons/icons.svg",
          height: cellWidth,
          width: cellHeight,
        );
      }
      return Text(cell.value.toString());
    }
    if (cell.isFlaged) {
      return SvgPicture.asset(
        "assets/icons/flag.svg",
        height: cellWidth,
        width: cellHeight,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<GameModel>(context, listen: false)
            .showValue(cell.x, cell.y);
      },
      onLongPress: () {
        Provider.of<GameModel>(context, listen: false).setFlag(cell.x, cell.y);
      },
      child: Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          // border: Border.all(
          //   //color: Color(0xFFF05A22),
          //   style: BorderStyle.solid,
          //   width: 1.0,
          // ),
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.0),
        ),
        // surfacecolor: styleconstant.maincolor,
        // parentcolor: styleconstant.maincolor,
        child: Center(
          child: getContent(),
        ),
      ),
    );
    // return ClayContainer(
    //   width: cellWidth,
    //   height: cellHeight,
    //   borderRadius: 5,
    //   color: Colors.grey.shade300,
    //   // surfaceColor: Colors.grey.shade300,
    //   // surfaceColor: Colors.grey.shade300,
    //   surfaceColor: StyleConstant.mainColor,
    //   parentColor: StyleConstant.mainColor,
    //   curveType: CurveType.concave,
    //   child: Center(
    //     child: getContent(),
    //   ),
    // );
  }
}
