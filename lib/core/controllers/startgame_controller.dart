import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/core/controllers/game_logic_controller.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:provider/provider.dart';

class StartGameController extends GetxController {
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
    Provider.of<GameLogicController>(context, listen: false)
        .initizialize(gameDifficulty);
    Get.toNamed(RouteConstant.minesweeperRoute);
  }
}
