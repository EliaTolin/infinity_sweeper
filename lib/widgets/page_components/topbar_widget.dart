import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Size size;
  final Function? onPressed;
  final Function? onTitleTapped;
  final Widget? child;

  @override
  final Size preferredSize;

  TopBar(this.size, this.title,
      {Key? key, this.child, this.onPressed, this.onTitleTapped})
      : preferredSize =
            Size.fromHeight(size.height * StyleConstant.kHeighBarRatio),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: preferredSize.height,
      child: buildTopBar(preferredSize, title),
    );
  }
}

Column buildTopBar(Size size, String title) {
  return Column(
    children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClayContainer(
            depth: 35,
            spread: 10,
            color: StyleConstant.mainColor,
            parentColor: StyleConstant.mainColor,
            surfaceColor: StyleConstant.mainColor,
            height: size.height,
            curveType: CurveType.concave,
            customBorderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(StyleConstant.radiusComponent),
              bottomLeft: Radius.circular(StyleConstant.radiusComponent),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 40,
                  // color: StyleConstant.textAppBarColor,
                  color: Colors.black87,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    ],
  );
}
