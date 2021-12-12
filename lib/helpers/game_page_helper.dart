import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/gamedifficulty_model.dart';
import 'package:infinity_sweeper/models/game_model.dart';
import 'package:provider/provider.dart';

void openGame(BuildContext context, Difficulty difficulty) {
  GameDifficulty gameDifficulty;
  switch (difficulty) {
    case Difficulty.easy:
      gameDifficulty = GameDifficulty.easy();
      break;
    case Difficulty.medium:
      gameDifficulty = GameDifficulty.medium();
      break;
    case Difficulty.difficult:
      gameDifficulty = GameDifficulty.difficulty();
      break;
  }
  Provider.of<GameModel>(context, listen: false)
      .initizialize(gameDifficulty);
  Navigator.of(context).pushNamed('/game');
}
