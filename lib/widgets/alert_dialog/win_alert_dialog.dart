import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

class WinDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Function action;
  final String durationGame;
  final bool isRecord;
  const WinDialogBox(
    this.title,
    this.descriptions,
    this.text,
    this.durationGame,
    this.isRecord,
    this.action, {
    Key? key,
  }) : super(key: key);

  @override
  _WinDialogBoxState createState() => _WinDialogBoxState();
}

class _WinDialogBoxState extends State<WinDialogBox> {
  static const double padding = 20;
  static const double avatarRadius = 45;
  late String timeUnitGame;

  @override
  void initState() {
    super.initState();
    final int count = ':'.allMatches(widget.durationGame).length;
    switch (count) {
      case 2:
        timeUnitGame = "Hours";
        break;
      case 1:
        timeUnitGame = "Minutes";
        break;
      case 0:
        timeUnitGame = "Seconds";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: const EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    widget.durationGame,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  AutoSizeText(
                    timeUnitGame,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              widget.isRecord
                  ? AutoSizeText(
                      "Time Record!",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: InkWell(
                    onTap: () => widget.action(),
                    child: ClayContainer(
                      borderRadius: 10,
                      curveType: CurveType.concave,
                      surfaceColor: Colors.white,
                      parentColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          widget.text,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/icons/win.png")),
          ),
        ),
      ],
    );
  }
}
