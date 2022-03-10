import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

String getDifficultyString(Difficulty difficulty, BuildContext context) {
  switch (difficulty) {
    case Difficulty.easy:
      return AppLocalizations.of(context)!.easy.toUpperCase();
    case Difficulty.medium:
      return AppLocalizations.of(context)!.medium.toUpperCase();
    case Difficulty.hard:
      return AppLocalizations.of(context)!.hard.toUpperCase();
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

String getDifficultyGridSizeString(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return '9x9';
    case Difficulty.medium:
      return '16x16';
    case Difficulty.hard:
      return '30x30';
  }
}
