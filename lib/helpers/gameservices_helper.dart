import 'dart:io';

import 'package:flutter/services.dart';
import 'package:games_services/games_services.dart';
import 'package:infinity_sweeper/constants/gameservices_constant.dart';
import 'package:infinity_sweeper/helpers/logger_helper.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';

class GamesServicesHelper {
  String _getLeaderBoardFromDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return GamesServicesConstant.idLeaderBoardEasy;
      case Difficulty.medium:
        return GamesServicesConstant.idLeaderBoardMedium;
      case Difficulty.hard:
        return GamesServicesConstant.idLeaderBoardHard;
    }
  }

  void loadGamesService() async {
    try {
      await GamesServices.signIn();
    } on PlatformException catch (e) {
      LoggerHelper.print(e.message);
    }
  }

  void submitScore(int score, Difficulty difficulty) async {
    String leaderBoardId = _getLeaderBoardFromDifficulty(difficulty);

    if (await GamesServices.isSignedIn) {
      Score gameScore;
      if (Platform.isAndroid) {
        gameScore = Score(androidLeaderboardID: leaderBoardId, value: score);
      } else if (Platform.isIOS) {
        gameScore = Score(iOSLeaderboardID: leaderBoardId, value: score);
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      GamesServices.submitScore(
        score: gameScore,
      );
    }
  }
}
