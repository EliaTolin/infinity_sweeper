import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/game/gamedata_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';

class GameDataProvider extends ChangeNotifier {
  late GameData _gameData;
  SharedPrefHelper sharedPref = SharedPrefHelper();

  void initializeData({SharedPrefHelper? sharedPref}) async {
    sharedPref = sharedPref ?? SharedPrefHelper();
    if (!await sharedPref.exist(DataConstant.data)) {
      _gameData = GameData();
      sharedPref.save(DataConstant.data, _gameData);
    } else {
      var data = await sharedPref.read(DataConstant.data);
      _gameData = GameData.fromJson(data);
    }
  }

  bool checkRecord(int timeGame, Difficulty difficulty) {
    String gameDifficulty = _getDifficultyDataString(difficulty);
    if (_gameData.recordTimeInSecond[gameDifficulty]! > timeGame ||
        _gameData.recordTimeInSecond[gameDifficulty] == 0) {
      _gameData.recordTimeInSecond[gameDifficulty] = timeGame;
      saveGame();
      return true;
    }
    return false;
  }

  GameData getGameData() => _gameData;

  void saveGame() {
    sharedPref.save(DataConstant.data, _gameData);
  }

  void addWin() {
    _gameData.addWin();
    saveGame();
  }

  void addLose() {
    _gameData.addLose();
    saveGame();
  }
}

String _getDifficultyDataString(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return DataConstant.recordEasy;
    case Difficulty.medium:
      return DataConstant.recordMedium;
    case Difficulty.hard:
      return DataConstant.recordHard;
  }
}
