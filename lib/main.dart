import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/binding/home_binding.dart';
import 'package:infinity_sweeper/pages/home_page.dart';
import 'package:infinity_sweeper/pages/minesweeper_page.dart';
import 'package:infinity_sweeper/pages/purchase_page.dart';
import 'package:infinity_sweeper/pages/splashscreen_page.dart';
import 'package:infinity_sweeper/pages/startgame_page.dart';
import 'package:infinity_sweeper/pages/stats_page.dart';
import 'constants/route_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  MobileAds.instance.initialize();
  await PurchaseApi.init();
  runApp(
    const InfinitySweeper(),
  );
}

class InfinitySweeper extends StatelessWidget {
  const InfinitySweeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Infinity MineSweeper",
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstant.splashRoute,
      getPages: [
        GetPage(
          name: RouteConstant.splashRoute,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: RouteConstant.homeRoute,
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: RouteConstant.minesweeperRoute,
          page: () => const MinesweeperPage(),
        ),
        GetPage(
          name: RouteConstant.statsRoute,
          page: () => const StatsPage(),
        ),
        GetPage(
          name: RouteConstant.purchaseRoute,
          page: () => const PurchasePage(),
        ),
        GetPage(
          name: RouteConstant.startGamesRoute,
          page: () => const StartGamePage(),
        ),
      ],
    );
  }
}
