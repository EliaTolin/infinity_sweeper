import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WinAlertDialog extends StatefulWidget {
  final String textButton1;
  final String textButton2;
  final String route;
  final String title;
  final String durationGame;
  const WinAlertDialog({
    Key? key,
    required this.title,
    required this.textButton1,
    required this.textButton2,
    required this.route,
    required this.durationGame,
  }) : super(key: key);

  @override
  _WinAlertDialogState createState() => _WinAlertDialogState();
}

class _WinAlertDialogState extends State<WinAlertDialog> {
  late String timeUnitGame;

  @override
  void initState() {
    super.initState();
    //Check unit of measure from number of units
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
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          AutoSizeText(
            widget.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          body(),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(widget.route, (route) => false);
              },
              child: Center(
                child: AutoSizeText(
                  widget.textButton1,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          "You completed game in :",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(
          height: 15,
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
      ],
    );
  }
}
