import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';

class OptionButton extends StatelessWidget {
  final String _text;
  final Function _fun;
  final double preferedWidth;
  const OptionButton(
    this._text,
    this._fun, {
    this.preferedWidth = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _width = preferedWidth == 0
            ? constraints.maxWidth * StyleConstant.kSizeButton
            : preferedWidth;
        return ClayContainer(
          borderRadius: 30,
          width: _width,
          // depth: 40,
          // spread: 20,
          curveType: CurveType.concave,
          surfaceColor: StyleConstant.mainColor,
          parentColor: StyleConstant.mainColor,
          child: TextButton(
            style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
            child: AutoSizeText(
              _text,
              maxLines: 1,
              style: const TextStyle(
                color: StyleConstant.textColor,
                fontSize: 24.0,
              ),
            ),
            onPressed: () => _fun(),
          ),
        );
      },
    );
  }
}
