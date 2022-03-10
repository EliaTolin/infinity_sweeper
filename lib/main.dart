import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/l10n/l10n.dart';
import 'package:infinity_sweeper/providers/purchase_provider.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'constants/route_constant.dart';
import 'routes/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
    return MaterialApp(
      title: "Infinity MineSweeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Futura Round'),
      onGenerateRoute: router.generateRoute,
      initialRoute: RouteConstant.splashRoute,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
    );
  }
}
