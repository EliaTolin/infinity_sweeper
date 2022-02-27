import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/models/game/gamedata_model.dart';

import 'indicator_widget.dart';

class PieChartStats extends StatefulWidget {
  final GameData gameData;

  const PieChartStats(this.gameData, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartStatsState();
}

class PieChartStatsState extends State<PieChartStats> {
  static const winIndex = 0;
  static const loseIndex = 1;
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(widget.gameData),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: StyleConstant.colorNumber[winIndex],
                text: 'Win',
                isSquare: false,
              ),
              const SizedBox(
                height: 4,
              ),
              Indicator(
                color: StyleConstant.colorNumber[loseIndex],
                text: 'Lose',
                isSquare: false,
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(GameData gameData) {
    int numWin = gameData.gameWin;
    int numLose = gameData.gameLose;

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case winIndex:
          return PieChartSectionData(
              color: StyleConstant.colorNumber[winIndex],
              value: numWin.toDouble(),
              title: numWin.toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: StyleConstant.textColor,
              ));
        case loseIndex:
          return PieChartSectionData(
            color: StyleConstant.colorNumber[loseIndex],
            value: numLose.toDouble(),
            title: numLose.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: StyleConstant.textColor,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
