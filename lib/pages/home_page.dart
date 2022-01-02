import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/homepage_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/widgets/page_components/button/option_button_widget.dart';
import 'package:infinity_sweeper/widgets/page_components/topbar_widget.dart';

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
              SvgPicture.asset(
                "assets/icons/icon.svg",
                height: 150,
                width: 150,
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
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionButton(
                      "Statistics",
                      () => Navigator.of(context)
                          .pushNamed(RouteConstant.statsRoute),
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