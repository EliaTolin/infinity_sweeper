import 'package:flutter/material.dart';
import 'package:infinity_sweeper/screens/components/app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBar(size, "Infinity Sweeper"),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-6.0, -6.0),
                blurRadius: 16.0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(6.0, 6.0),
                blurRadius: 16.0,
              ),
            ],
            color: const Color(0xFFEFEEEE),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Ciao Mondo!",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
