import 'package:flutter/material.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBar(size, "Infinity Sweeper"),
      body: const Center(
        child: Text("InfinitySweeper"),
      ),
    );
  }
}
