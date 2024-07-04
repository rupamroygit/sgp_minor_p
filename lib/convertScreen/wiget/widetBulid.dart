// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sciencetific_calculator/convertScreen/data/unit.dart';
import 'package:sciencetific_calculator/convertScreen/listViewFirstPage/backViewConversion/catagory-Tiles-View.dart';

const double _rowHeight = 75;
final BorderRadius _borderRadius = BorderRadius.circular(_rowHeight / 2);

// ignore: must_be_immutable
class Category extends StatelessWidget {
  final String name;
  final String? icon;
  final List<Unit> units;

  const Category(
      {super.key, required this.name, required this.icon, required this.units});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepOrange.shade50,
        child: SizedBox(
          height: _rowHeight,
          child: InkWell(
            borderRadius: _borderRadius,
            highlightColor: Colors.deepOrange[200],
            splashColor: Colors.deepOrange[200],
            onTap: () {
              _navigateToConverter(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(icon!)),
                  Center(
                      child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _navigateToConverter(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CategoryTilesView(name: name, units: units);
    }));
  }
}
