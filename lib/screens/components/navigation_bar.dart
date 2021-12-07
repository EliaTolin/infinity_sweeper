import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';

class NavigationBar extends StatelessWidget {
  final double maxHeight;
  const NavigationBar(
    this.maxHeight, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight * StyleConstant.kHeighBarRatio,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(StyleConstant.kPaddingComponent),
        child: ClayContainer(
          borderRadius: 5,
          curveType: CurveType.concave,
          surfaceColor: StyleConstant.mainColor,
          parentColor: StyleConstant.mainColor,
          // color: Colors.amber,
          child: IconButton(
            icon: const Icon(Icons.home),
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
