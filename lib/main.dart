import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/providers/purchase_provider.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'constants/route_constant.dart';
import 'config/routes/router.dart' as router;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchaseApi.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => PurchaseProvider(), lazy: false),
        ChangeNotifierProvider(create: (context) => GameModelProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => GameDataProvider()),
      ],
      child: const InfinitySweeper(),
    ),
  );
}

class InfinitySweeper extends StatelessWidget {
  const InfinitySweeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Infinity MineSweeper",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      initialRoute: RouteConstant.splashRoute,
    );
  }
}
