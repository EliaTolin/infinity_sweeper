import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/models/game_model.dart';
import 'package:provider/provider.dart';

class InfoBar extends StatefulWidget {
  final double maxHeight;
  const InfoBar(
    this.maxHeight, {
    Key? key,
  }) : super(key: key);

  @override
  InfoBarState createState() => InfoBarState();
}

class InfoBarState extends State<InfoBar> {
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight * StyleConstant.kHeighBarRatio,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(StyleConstant.kPaddingComponent),
        child: ClayContainer(
          borderRadius: 5,
          curveType: CurveType.concave,
          surfaceColor: StyleConstant.mainColor,
          parentColor: StyleConstant.mainColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<GameModel>(
                  builder: (context, gameModel, child) {
                    int numFlag =
                        Provider.of<GameModel>(context, listen: false).numFlag;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            numFlag.toString(),
                            style: const TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          const AutoSizeText(
                            "BOMB",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 40,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
