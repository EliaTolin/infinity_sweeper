import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';

//TO DO
//Delete the unused variable

Column buildTopBar(Size size, String title) {
  return Column(
    children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: size.height,
            decoration: const BoxDecoration(
              color: StyleConstant.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(StyleConstant.radiusComponent),
                bottomRight: Radius.circular(StyleConstant.radiusComponent),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  color: StyleConstant.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    ],
  );
}

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
