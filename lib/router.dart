import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constant/route_constant.dart';
import 'package:infinity_sweeper/screens/homepage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstant.mainRoute:
      return MaterialPageRoute(builder: (context) => const HomePage());
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
      appBar: AppBar(title: const Text("Undefited View")),
      body: Center(
        child: Text("Route for $name is not defined"),
      ),
    );
  }
}
