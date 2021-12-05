import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/style_constant.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/screens/page_arguments/game_arguments.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'components/widget/option_card.dart';

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
                    child: OptionCard(
                      "Easy",
                      () => {
                        Navigator.of(context)
                            .pushNamed('/game', arguments: GameArguments(10, 3))
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard(
                      "Medium",
                      () => {
                        Navigator.of(context)
                            .pushNamed('/game', arguments: GameArguments(20, 5))
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard(
                      "Difficult",
                      () => {
                        Navigator.of(context).pushNamed('/game',
                            arguments: GameArguments(30, 10))
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8),
                  //   child: OptionCard("Settings", () => {}),
                  // ),
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
