import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/screens/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'models/providers/gamedata_provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Provider.of<GameDataProvider>(context, listen: false).initializeData();
    return EasySplashScreen(
      logo: Image.asset('assets/icons/icon_trasparent.png'),
      title: const Text(
        "Infinity MineSweeper",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: StyleConstant.mainColor,
      showLoader: false,
      loadingText: const Text("Loading..."),
      navigator: const HomePage(),
      durationInSeconds: 5,
    );
  }
}
