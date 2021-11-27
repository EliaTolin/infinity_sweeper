import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';

class OptionCard extends StatelessWidget {
  final String _text;
  final Function _fun;
  final double preferedWidth;
  const OptionCard(
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
        return Container(
          width: _width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: StyleConstant.optionButtonColor,
            borderRadius: BorderRadius.all(
                Radius.circular(StyleConstant.radiusComponent)),
          ),
          child: TextButton(
            child: AutoSizeText(
              _text,
              maxLines: 1,
              style: const TextStyle(
                color: StyleConstant.textColor,
                fontSize: 20.0,
              ),
            ),
            onPressed: () => _fun(),
          ),
        );
      },
    );
  }
}
