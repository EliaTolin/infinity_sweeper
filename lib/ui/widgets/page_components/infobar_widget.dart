import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/route_constant.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/providers/game_provider.dart';
import 'package:infinity_sweeper/providers/time_provider.dart';
import 'package:infinity_sweeper/ui/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoBar extends StatefulWidget {
  final double maxHeight;
  const InfoBar(
    this.maxHeight, {
    Key? key,
  }) : super(key: key);

  @override
  InfoBarState createState() => InfoBarState();
}

class InfoBarState extends State<InfoBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight * StyleConstant.kHeighBarRatio,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(StyleConstant.kPaddingComponent),
        child: ClayContainer(
          borderRadius: 5,
          curveType: CurveType.concave,
          surfaceColor: StyleConstant.mainColor,
          parentColor: StyleConstant.mainColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<GameModelProvider>(
                  builder: (context, gameModel, child) {
                    int numFlag =
                        Provider.of<GameModelProvider>(context, listen: false)
                            .numFlag;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: numFlag.toString(),
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                                TextSpan(
                                  text: " " +
                                      AppLocalizations.of(context)!
                                          .bombs
                                          .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey.shade800,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Consumer<TimerProvider>(
                  builder: (context, timeProvider, child) {
                    return AutoSizeText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: timeProvider.getString(),
                            style: const TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          TextSpan(
                            text: " " +
                                AppLocalizations.of(context)!
                                    .time
                                    .toUpperCase(),
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey.shade800,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 40,
                  onPressed: () {
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return CustomDialogBox(
                          AppLocalizations.of(context)!.gamePauseTitle,
                          AppLocalizations.of(context)!.gamePauseDescr,
                          AppLocalizations.of(context)!.home,
                          "assets/icons/home.png",
                          () => Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteConstant.homeRoute, (route) => false),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
