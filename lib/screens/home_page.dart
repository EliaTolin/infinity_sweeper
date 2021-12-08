import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/helpers/game_page_helper.dart';
import 'package:infinity_sweeper/models/difficulty_model.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'components/widget/option_button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBar(size, "Infinity Sweeper"),
      backgroundColor: StyleConstant.mainColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SimpleShadow(
                child: SvgPicture.asset(
                  "assets/icons/icons.svg",
                  height: 100,
                  width: 100,
                ),
                opacity: 0.6, // Default: 0.5
                color: Colors.black, // Default: Black
                offset: const Offset(5, 5), // Default: Offset(2, 2)
                sigma: 5, // Default: 2
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionButton(
                      "Easy",
                      () => openGame(context, Difficulty.easy),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionButton(
                      "Medium",
                      () => openGame(context, Difficulty.medium),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionButton(
                      "Difficult",
                      () => openGame(context, Difficulty.difficult),
                    ),
                  ),
                ],
              ),
              const AutoSizeText("Develop by Tolin Elia",
                  style: TextStyle(color: StyleConstant.textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
