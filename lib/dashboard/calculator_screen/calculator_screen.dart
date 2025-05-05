import 'package:flutter/material.dart';
import '../../screen_util.dart';
import 'bottom_sheet_widget.dart';
import 'calculation_row.dart'; // Import CalculationRow
import 'package:cash_easy/image_constants.dart'; // Import Image Constants

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final Map<int, int> _values = {}; // Stores user inputs per fixedValue
  int _resetKey = 0; // Key to force widget rebuild
  int _totalInputSum = 0; // Sum of all text field values

  // List of denominations
  final List<Map<String, dynamic>> _denominations = [
    {"image": ImageConstants.fiveHINR, "value": 500},
    {"image": ImageConstants.twoHKINR, "value": 200},
    {"image": ImageConstants.oneHINR, "value": 100},
    {"image": ImageConstants.fiftyINR, "value": 50},
    {"image": ImageConstants.twentyINR, "value": 20},
    {"image": ImageConstants.tenINR, "value": 10},
    {"image": ImageConstants.fiveINR, "value": 5},
  ];

  // Updates total when a row changes its input
  void _updateTotal(int fixedValue, int userInput) {
    setState(() {
      if (userInput > 0) {
        _values[fixedValue] = userInput;
      } else {
        _values.remove(fixedValue); // Remove if input is 0
      }
      _calculateTotals();
    });
  }

  // Calculate total amount & sum of inputs
  void _calculateTotals() {
    int totalAmount = 0;
    int totalInputs = 0;
    _values.forEach((fixedValue, userInput) {
      totalAmount += fixedValue * userInput;
      totalInputs += userInput;
    });

    setState(() {
      _totalInputSum = totalInputs; // Update total input sum
    });
  }

  // Reset all inputs and totals
  void _resetAll() {
    setState(() {
      _values.clear(); // Clear stored inputs
      _resetKey++; // Change key to force widget rebuild
      _totalInputSum = 0; // Reset input sum
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = _values.entries.fold(0, (sum, entry) => sum + entry.key * entry.value);

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Calculate", style: TextStyle(fontSize: 30)),
        actions: [
          IconButton(
            onPressed: _resetAll, // Call reset function
            icon: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.delete_outline, size: 40),
            ),
          ),
        ],
      ),
      body:
      Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: ScreenUtil.scaleH(120)), // Responsive padding
              child: Column(
                children: _denominations.map((denomination) {
                  return CalculationRow(
                    key: ValueKey("$_resetKey-${denomination["value"]}"), // Unique key for each row
                    imagePath: denomination["image"],
                    fixedValue: denomination["value"],
                    onValueChanged: _updateTotal,
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: BottomSheetWidget(
              totalAmount: totalAmount,
              totalInputs: _totalInputSum, // Pass sum of inputs to BottomSheet
            ),
          ),
        ],
      ),
    );
  }
}
