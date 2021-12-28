import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/helpers/sharedpref_helper.dart';
import 'package:infinity_sweeper/models/gamedata_model.dart';

Future<GameData> loadData({SharedPrefHelper? sharedPref}) async {
  sharedPref = sharedPref ?? SharedPrefHelper();
  if (!await sharedPref.exist(DataConstant.data)) {
    sharedPref.save(DataConstant.data, GameData());
  }
  var data = await sharedPref.read(DataConstant.data);
  return GameData.fromJson(data);
}
