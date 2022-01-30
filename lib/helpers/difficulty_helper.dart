import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:provider/provider.dart';

void openDifficultyGame(BuildContext context, Difficulty difficulty) {
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

Difficulty getDifficultyFromIndex(int index) {
  switch (index) {
    case 1:
      return Difficulty.easy;
    case 2:
      return Difficulty.medium;
    case 3:
      return Difficulty.hard;
    default:
      throw Exception("Difficulty not exist");
  }
}

String getDifficultyString(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return "EASY";
    case Difficulty.medium:
      return "MEDIUM";
    case Difficulty.hard:
      return "HARD";
  }
}

String getDifficultyBombString(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return "10";
    case Difficulty.medium:
      return "40";
    case Difficulty.hard:
      return "150";
  }
}

Widget getDifficultyIcon(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return ClayText(
        "9x9",
        emboss: false,
        color: StyleConstant.listColors[0],
        parentColor: StyleConstant.listColors[0],
        textColor: StyleConstant.listColors[0],
        style: TextStyle(
          color: StyleConstant.listColors[0],
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      );
    case Difficulty.medium:
      return ClayText(
        "16x16",
        emboss: false,
        color: StyleConstant.listColors[1],
        parentColor: StyleConstant.listColors[1],
        textColor: StyleConstant.listColors[1],
        style: TextStyle(
          color: StyleConstant.listColors[1],
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      );
    case Difficulty.hard:
      return ClayText(
        "30x30",
        emboss: false,
        color: StyleConstant.listColors[2],
        parentColor: StyleConstant.listColors[2],
        textColor: StyleConstant.listColors[2],
        style: TextStyle(
          color: StyleConstant.listColors[2],
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      );
  }
}
