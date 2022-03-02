import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gameservices_helper.dart';
import 'package:infinity_sweeper/pages/home_page.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreen> {
  GamesServicesHelper gamesServicesHelper = GamesServicesHelper();
  @override
  void initState() {
    super.initState();
    gamesServicesHelper.loadGamesService();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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