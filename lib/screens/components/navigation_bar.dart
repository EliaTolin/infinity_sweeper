import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 50,
      child: IconButton(
        icon: const Icon(Icons.ac_unit),
        iconSize: 40,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
