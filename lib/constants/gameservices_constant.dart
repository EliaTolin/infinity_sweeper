import 'dart:io';

class GamesServicesConstant {
  static String get idLeaderBoardEasy {
    if (Platform.isAndroid) {
      return 'CgkIo8GA57QREAIQBg';
    } else if (Platform.isIOS) {
      return 'easy_mode_leaderboard';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get idLeaderBoardMedium {
    if (Platform.isAndroid) {
      return 'CgkIo8GA57QREAIQAg';
    } else if (Platform.isIOS) {
      return 'medium_mode_leaderboard';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get idLeaderBoardHard {
    if (Platform.isAndroid) {
      return 'CgkIo8GA57QREAIQAw';
    } else if (Platform.isIOS) {
      return 'hard_mode_leaderboard';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
