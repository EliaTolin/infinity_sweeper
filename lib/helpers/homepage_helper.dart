import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
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
    case Difficulty.hard:
      gameDifficulty = GameDifficulty.hard();
      break;
  }
  Provider.of<GameModelProvider>(context, listen: false)
      .initizialize(gameDifficulty);
  Navigator.of(context).pushNamed(RouteConstant.minesweeperRoute);
}
