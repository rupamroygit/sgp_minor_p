import 'package:flutter/material.dart';
import 'package:sciencetific_calculator/navigation/bottom_navigation.dart';

void main() {
  runApp(const Screen());
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Calculator"),
        ),
        body: const Navigation(),
      ),
    );
  }
}
