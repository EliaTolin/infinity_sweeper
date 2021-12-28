import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/helpers/gamedata_helper.dart';
import 'package:infinity_sweeper/models/gamedata_model.dart';

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}

class PieChartStats extends StatefulWidget {
  const PieChartStats({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  static const winIndex = 0;
  static const loseIndex = 1;
  int touchedIndex = -1;
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
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
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
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
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
                      sections: showingSections()),
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
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    int numWin = gameData.gameWin;
    int numLose = gameData.gameLose;
    late String percLose;
    late String percWin;
    int totalGames = numWin + numLose;
    if (totalGames != 0) {
      double tmpWin = (totalGames / numWin) * 100;
      percWin = tmpWin.toStringAsFixed(2) + " %";

      double tmpLose = (totalGames / numLose) * 100;
      percLose = tmpLose.toStringAsFixed(2) + " %";
    } else {
      percLose = percWin = "0%";
    }

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case winIndex:
          return PieChartSectionData(
              color: StyleConstant.colorNumber[winIndex],
              value: numWin.toDouble(),
              title: percWin,
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
            title: percLose,
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
