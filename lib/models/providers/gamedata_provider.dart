import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/infogame_model.dart';

class GameDataProvider with ChangeNotifier {
  SharedPrefHelper sharePref = SharedPrefHelper();
  InfoGame info = InfoGame();

  void initizialize() async {
    if (!sharePref.exist(DataConstant.data)) {
      sharePref.save(DataConstant.data, info);
    } else {
      info = InfoGame.fromJson(await sharePref.read(DataConstant.data));
    }
  }

  void addLose() {
    info.addLose();
    sharePref.save(DataConstant.data, info);
  }

  void addWin() {
    info.addWin();
    sharePref.save(DataConstant.data, info);
  }
}
