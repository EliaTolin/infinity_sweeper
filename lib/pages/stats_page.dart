import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_sweeper/constants/data_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/models/game/gamedata_model.dart';
import 'package:infinity_sweeper/providers/gamedata_provider.dart';
import 'package:infinity_sweeper/widgets/page_components/graph/stats_pie_chart.dart';
import 'package:infinity_sweeper/widgets/page_components/topbar_back_widget.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  GameData gameData = GameData();
  @override
  void initState() {
    super.initState();
    gameData =
        Provider.of<GameDataProvider>(context, listen: false).getGameData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBarBack("Game statistics", size),
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
              Column(
                children: [
                  ClayContainer(
                    borderRadius: 5,
                    curveType: CurveType.none,
                    surfaceColor: StyleConstant.mainColor,
                    parentColor: StyleConstant.mainColor,
                    color: StyleConstant.mainColor,
                    child: getRecordElement(
                        "easy",
                        gameData.recordTimeInSecond[DataConstant.recordEasy],
                        StyleConstant.listColors[0]),
                  ),
                  const SizedBox(height: 10),
                  ClayContainer(
                    borderRadius: 5,
                    curveType: CurveType.none,
                    surfaceColor: StyleConstant.mainColor,
                    parentColor: StyleConstant.mainColor,
                    color: StyleConstant.mainColor,
                    child: getRecordElement(
                        "medium",
                        gameData.recordTimeInSecond[DataConstant.recordMedium],
                        StyleConstant.listColors[1]),
                  ),
                  const SizedBox(height: 10),
                  ClayContainer(
                    borderRadius: 5,
                    curveType: CurveType.none,
                    surfaceColor: StyleConstant.mainColor,
                    parentColor: StyleConstant.mainColor,
                    color: StyleConstant.mainColor,
                    child: getRecordElement(
                        "hard",
                        gameData
                            .recordTimeInSecond[DataConstant.recordHard],
                        StyleConstant.listColors[2]),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding getRecordElement(String difficulty, int? second, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
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
