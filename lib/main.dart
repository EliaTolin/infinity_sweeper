import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/game_model.dart';
import 'constant/route_constant.dart';
import 'router.dart' as router;
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GameModel()),
        ],
        child: const InfinitySweeper(),
      ),
    );

class InfinitySweeper extends StatelessWidget {
  const InfinitySweeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Prova",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      initialRoute: RouteConstant.splashRoute,
    );
  }
}
