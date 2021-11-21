import 'package:flutter/material.dart';
import 'constant/route_constant.dart';
import 'router.dart' as router;

void main() => runApp(const InfinitySweeper());

class InfinitySweeper extends StatelessWidget {
  const InfinitySweeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Prova",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      initialRoute: RouteConstant.mainRoute,
    );
  }
}
