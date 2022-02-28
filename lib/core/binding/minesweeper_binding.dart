import 'package:get/instance_manager.dart';
import 'package:infinity_sweeper/core/controllers/game_provider.dart';
import 'package:infinity_sweeper/core/controllers/minesweeper_controllers.dart';

class MineSweeperBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MinesweeperController());
    Get.put(GameLogicController());
  }
}
