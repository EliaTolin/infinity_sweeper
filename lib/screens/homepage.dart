import 'package:flutter/material.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/widget/option_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBar(size, "Infinity Sweeper"),
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
                "assets/icons/bomb.svg",
                height: 100,
                width: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard("Easy", () => {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard("Medium", () => {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard("Difficult", () => {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OptionCard("Settings", () => {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
