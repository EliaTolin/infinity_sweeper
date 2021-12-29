import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gamedata_helper.dart';
import 'package:infinity_sweeper/models/gamedata_model.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';
import 'package:infinity_sweeper/screens/components/stats_pie_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  GameData gameData = GameData();

  void initizialize() async {
    gameData = await loadData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initizialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBar(size, "Game statistics"),
      backgroundColor: StyleConstant.mainColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClayContainer(
                borderRadius: 5,
                curveType: CurveType.none,
                surfaceColor: StyleConstant.mainColor,
                parentColor: StyleConstant.mainColor,
                color: StyleConstant.mainColor,
                child: PieChartStats(gameData),
              ),
              const SizedBox(height: 20),
              ClayContainer(
                borderRadius: 5,
                curveType: CurveType.none,
                surfaceColor: StyleConstant.mainColor,
                parentColor: StyleConstant.mainColor,
                color: StyleConstant.mainColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      getRecordElement("easy",
                          gameData.recordTimeInSecond[DataConstant.recordEasy]),
                      getRecordElement(
                          "medium",
                          gameData
                              .recordTimeInSecond[DataConstant.recordMedium]),
                      getRecordElement(
                          "difficult",
                          gameData.recordTimeInSecond[
                              DataConstant.recordDifficult]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column getRecordElement(String difficulty, int? second) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(
              "Your record for " + difficulty + " is :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: StyleConstant.textColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AutoSizeText(
              formatHHMMSS(second!),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formatHHMMSS(int seconds) {
    if (seconds != 0) {
      int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String hoursStr = (hours).toString().padLeft(2, '0');
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      if (hours == 0) {
        return "$minutesStr:$secondsStr";
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    } else {
      return "";
    }
  }
}
