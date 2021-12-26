import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/gamedata_model.dart';
import 'package:infinity_sweeper/models/providers/time_provider.dart';
import 'package:infinity_sweeper/screens/components/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:infinity_sweeper/screens/components/widgets/alert_dialog/win_alert_dialog.dart';
import 'package:provider/provider.dart';

void computeWinGame(BuildContext context, GameData gameData) {
  SharedPrefHelper sharedPref = SharedPrefHelper();
  bool record = false;
  Provider.of<TimerProvider>(context, listen: false).stopTimer(notify: false);
  int durationGame =
      Provider.of<TimerProvider>(context, listen: false).getTimeInSecond();
  if (gameData.recordTimeInSecond > durationGame ||
      gameData.recordTimeInSecond == 0) {
    record = true;
    gameData.recordTimeInSecond = durationGame;
  }
  gameData.addWin();
  sharedPref.save(DataConstant.data, gameData);
  showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return WinAlertDialog(
        title: "You win!",
        textButton1: "Home",
        textButton2: "Show grid",
        route: RouteConstant.homeRoute,
        durationGame: durationGame.toString(),
        record: record,
      );
    },
  );
}

void computeLoseGame(BuildContext context, GameData gameData) {
  SharedPrefHelper sharedPref = SharedPrefHelper();
  Provider.of<TimerProvider>(context, listen: false).stopTimer(notify: false);
  gameData.addLose();
  sharedPref.save(DataConstant.data, gameData);
  showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return const CustomAlertDialog(
        title: "You lose!",
        description: "When you lose, don't miss the lesson",
        textButton1: "Home",
        textButton2: "Show grid",
        route: RouteConstant.homeRoute,
      );
    },
  );
}
