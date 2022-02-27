import 'package:get/get.dart';
import 'package:infinity_sweeper/controllers/home_controllers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
