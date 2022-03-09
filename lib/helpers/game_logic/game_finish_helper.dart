import 'dart:io';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/helpers/games_service/gameservices_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'package:infinity_sweeper/ui/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:infinity_sweeper/ui/widgets/alert_dialog/win_alert_dialog.dart';
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
  String gameTime =
      Provider.of<TimerProvider>(context, listen: false).getString();
  showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return WinDialogBox(
        "You win!",
        "You completed game in :",
        "Home",
        gameTime,
        record,
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstant.startGamesRoute, (route) => false),
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
      return CustomDialogBox(
        "You lose!",
        "When you lose, don't miss the lesson",
        "Home",
        "assets/icons/home.png",
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstant.startGamesRoute, (route) => false),
      );
    },
  );
}
