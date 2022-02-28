import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/helpers/gameservices_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'package:infinity_sweeper/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:infinity_sweeper/widgets/alert_dialog/win_alert_dialog.dart';
import 'package:provider/provider.dart';

void computeWinGame(BuildContext context, Difficulty gameDifficulty) {
  GamesServicesHelper gamesServicesHelper = GamesServicesHelper();

  bool record = false;

  Provider.of<TimerProvider>(context, listen: false).stopTimer(notify: false);

  int durationGame =
      Provider.of<TimerProvider>(context, listen: false).getTimeInSecond();

  record = Provider.of<GameDataProvider>(context, listen: false)
      .checkRecord(durationGame, gameDifficulty);

  Provider.of<GameDataProvider>(context, listen: false).addWin();

  int scoreTime = 0;

  if (Platform.isAndroid) {
    scoreTime = Provider.of<TimerProvider>(context, listen: false)
        .getTimeInMillisecond();
  } else if (Platform.isIOS) {
    scoreTime = Provider.of<TimerProvider>(context, listen: false)
        .getTimeInHundredthOfSecond();
  }

  gamesServicesHelper.submitScore(scoreTime, gameDifficulty);

  showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return WinAlertDialog(
        title: "You win!",
        textButton1: "Home",
        textButton2: "Show grid",
        route: RouteConstant.startGamesRoute,
        durationGame: durationGame.toString(),
        record: record,
      );
    },
  );
}

void computeLoseGame(BuildContext context) {
  Provider.of<TimerProvider>(context, listen: false).stopTimer(notify: false);

  Provider.of<GameDataProvider>(context, listen: false).addLose();

  showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return const CustomAlertDialog(
        title: "You lose!",
        description: "When you lose, don't miss the lesson",
        textButton1: "Home",
        textButton2: "Show grid",
        route: RouteConstant.startGamesRoute,
      );
    },
  );
}
