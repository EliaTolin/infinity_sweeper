import 'package:games_services/games_services.dart';
import 'package:infinity_sweeper/constants/gameservices_constant.dart';
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
      GamesServices.signIn();
    } on Exception catch (_) {}
  }

  void submitScore(int score, Difficulty difficulty) async {
    String leaderBoardId = _getLeaderBoardFromDifficulty(difficulty);

    if (await GamesServices.isSignedIn) {
      GamesServices.submitScore(
        score: Score(
            androidLeaderboardID: leaderBoardId,
            iOSLeaderboardID: leaderBoardId,
            value: score),
      );
    }
  }
}
