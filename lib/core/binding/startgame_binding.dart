import 'package:get/get.dart';
import 'package:infinity_sweeper/core/controllers/startgame_controller.dart';

class StartGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StartGameController());
  }
}
