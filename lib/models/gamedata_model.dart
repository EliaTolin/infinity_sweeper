import 'package:infinity_sweeper/constants/data_constant.dart';

class GameData {
  int gameWin = 0;
  int gameLose = 0;
  Map<String, dynamic> recordTimeInSecond = {
    DataConstant.recordEasy: 0,
    DataConstant.recordMedium: 0,
    DataConstant.recordDifficult: 0
  };

  GameData();

  GameData.fromJson(Map<String, dynamic> json)
      : gameWin = json['gameWin'],
        gameLose = json['gameLose'],
        recordTimeInSecond = json['recordTimeInSecond'];

  Map<String, dynamic> toJson() => {
        'gameWin': gameWin,
        'gameLose': gameLose,
        'recordTimeInSecond': recordTimeInSecond,
      };

  void addLose() => gameLose++;

  void addWin() => gameWin++;
}
