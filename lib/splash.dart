import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/screens/homepage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
          'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
      title: const Text(
        "Infinity MineSweeper",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: const HomePage(),
      durationInSeconds: 5,
    );
  }
}
