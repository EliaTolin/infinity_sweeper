import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/screens/pages/game_page.dart';
import 'package:infinity_sweeper/screens/pages/home_page.dart';
import 'package:infinity_sweeper/screens/pages/stats_page.dart';
import 'package:infinity_sweeper/splash.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstant.splashRoute:
      return MaterialPageRoute(builder: (context) => const Splash());
    case RouteConstant.homeRoute:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case RouteConstant.gameRoute:
      return MaterialPageRoute(builder: (context) => const GamePage());
    case RouteConstant.statsRoute:
      return MaterialPageRoute(builder: (context) => const StatsPage());
  }
  return MaterialPageRoute(
      builder: (context) => UndefinitedScreen(name: settings.name));
}

class UndefinitedScreen extends StatelessWidget {
  final String? name;
  const UndefinitedScreen({Key? key, this.name = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Undefinited View")),
      body: Center(
        child: Text("Route for $name is not defined"),
      ),
    );
  }
}
