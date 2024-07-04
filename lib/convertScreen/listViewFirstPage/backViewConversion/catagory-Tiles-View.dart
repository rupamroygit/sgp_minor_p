import 'package:flutter/material.dart';
import 'package:sciencetific_calculator/convertScreen/data/api.dart';
import 'package:sciencetific_calculator/convertScreen/data/unit.dart';

class CategoryTilesView extends StatefulWidget {
  final String name;
  final List<Unit> units;

  const CategoryTilesView({super.key, required this.name, required this.units});

  @override
  State<CategoryTilesView> createState() => _CategoryTilesViewState();
}

class _CategoryTilesViewState extends State<CategoryTilesView> {
  Unit? _fromValue;
  Unit? _toValue;
  double? _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem<String>>? _unitMenuItems;
  bool _showValidationError = false;
  bool _showErrorUI = false;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.deepOrange.shade50,
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: !(widget.name == apiCategory['name'] && _showErrorUI)
          ? OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Column(
                    children: [
                      buildInput(),
                      buildArrows(),
                      buildOutput(),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      width: 450,
                      child: ListView(
                        children: [
                          buildInput(),
                          buildArrows(),
                          buildOutput(),
                        ],
                      ),
                    ),
                  );
                }
              },
            )
          : showError(),
    );
  }

///////////////////////////
//////HelperMethod////////

  /// Sets the default values for the 'from' and 'to' [Dropdown]s.
  void _setDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });

    if (_inputValue != null) {
      _updateConversion();
    }
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() async {
    if (widget.name == apiCategory['name']) {
      final api = ApiService();
      final conversion = await api.convert(apiCategory['route']!,
          _inputValue.toString(), _fromValue!.name, _toValue!.name);

      // API error or not connected to the internet
      if (conversion == null) {
        setState(() {
          _showErrorUI = true;
        });
      } else {
        setState(() {
          _showErrorUI = false;
          _convertedValue = _format(conversion);
        });
      }
    } else {
      // For the static units, we do the conversion ourselves
      setState(() {
        _convertedValue = _format(
            _inputValue! * (_toValue!.conversion / _fromValue!.conversion));
      });
    }
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit? _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName as String);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName as String);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

///////////////////////////
///////////////////////////

///////////////////////////
//////HelperWidgets////////

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem<String>>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem<String>(
        value: unit.name,
        child: Text(
          unit.name,
          softWrap: true,
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  Widget _createDropdown(
      String? currentValue, ValueChanged<dynamic> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: OutlineInputBorder()),
        value: currentValue,
        items: _unitMenuItems,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Padding buildInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              errorText: _showValidationError ? "Invalid number entered" : null,
              labelText: "Input",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _updateInputValue(value);
            },
          ),
          _createDropdown(_fromValue?.name, _updateFromConversion)
        ],
      ),
    );
  }

  Widget buildArrows() {
    return const RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );
  }

  Padding buildOutput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: TextEditingController()..text = _convertedValue,
            decoration: const InputDecoration(
              labelText: "Output",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          _createDropdown(_toValue?.name, _updateToConversion),
        ],
      ),
    );
  }

  Widget showError() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.red,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 180.0,
              color: Colors.white,
            ),
            Text(
              "Oh no! We can't connect right now!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
