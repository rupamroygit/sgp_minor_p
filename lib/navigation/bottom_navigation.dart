// ignore: file_names
import "package:flutter/material.dart";
import "package:sciencetific_calculator/calculatorscreen/simplescreen/main_screen.dart";
import "package:sciencetific_calculator/convertScreen/listViewFirstPage/catagory_view.dart";

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _indexOfscreen = 0;

  void _workNavigationbar(int index) {
    setState(() {
      _indexOfscreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> page = [
      const CalculatorScreen(),
      const CatagoryView(),
    ];
    return Material(
        color: const Color.fromARGB(167, 193, 191, 128),
        child: Scaffold(
          body: page[_indexOfscreen],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _indexOfscreen,
            onTap: _workNavigationbar,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: "Calculator",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.auto_mode), label: "Converter"),
            ],
          ),
        ));
  }
}
