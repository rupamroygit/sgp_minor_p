// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sciencetific_calculator/convertScreen/data/unit.dart';
import 'package:sciencetific_calculator/convertScreen/wiget/widetBulid.dart';

final _backgroundColor = Colors.deepOrange[100];

class CatagoryView extends StatefulWidget {
  const CatagoryView({super.key});

  @override
  State<CatagoryView> createState() => _ListViewOfFirstPageState();
}

class _ListViewOfFirstPageState extends State<CatagoryView> {
  List<Category> categories = [];
  static const _icons = {
    'Length': 'assets/icons/length.png',
    'Area': 'assets/icons/area.png',
    'Volume': 'assets/icons/volume.png',
    'Mass': 'assets/icons/mass.png',
    'Time': 'assets/icons/time.png',
    'Digital Storage': 'assets/icons/digital_storage.png',
    'Energy': 'assets/icons/power.png',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (categories.isEmpty) {
      await _retrieveLocalCategories();
    }
  }

  Future<void> loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/regular_units.json');
    // ignore: unused_local_variable
    final data = jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      body: categories.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildCategoryWidgets(categories),
    );
  }

  Future<void> _retrieveLocalCategories() async {
    final json = await rootBundle.loadString('assets/data/regular_units.json');
    final data = const JsonDecoder().convert(json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    // ignore: unused_local_variable
    var categoryIndex = 0;
    for (var key in data.keys) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        icon: _icons[key],
        units: units,
      );
      setState(() {
        categories.add(category);
      });
      categoryIndex += 1;
    }
  }

  Widget _buildCategoryWidgets(List<Category> categories) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return categories[index];
          });
    } else {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 3),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return categories[index];
          });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Unit Converter",
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
    );
  }
}
