import 'package:flutter/material.dart';
import '../../Database/saved_calculation_table.dart';
import '../../screen_util.dart';
import 'bottom_sheet_widget.dart';
import 'calculation_row.dart';
import 'package:cash_easy/image_constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  final Map<int, int> _values = {}; // Stores user inputs per fixedValue
  int _resetKey = 0; // Key to force widget rebuild
  int _totalInputSum = 0; // Sum of all text field values
  late AnimationController _animationController; // Animation Controller

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust animation duration as needed
    );
  }

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

  // Save the current calculation
  Future<void> _saveCalculation() async {
    int totalAmount = _values.entries.fold(0, (sum, entry) => sum + entry.key * entry.value);

    // Create a SavedCalculation object
    SavedCalculation savedCalculation = SavedCalculation(
      fixedValue: _values.keys.first, // Use the first fixed value (for example)
      userInput: _values[_values.keys.first]!, // Use the first user input
      result: totalAmount, // The total amount
      totalCalculation: totalAmount, // Total calculation (same as result here)
    );

    // Insert the saved calculation into the database
    await DatabaseHelper.instance.insertOrUpdateSavedCalculation(savedCalculation);

    // Optionally, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calculation Saved Successfully!')),
    );
  }

  // Reset all inputs and totals
  void _resetAll() {
    setState(() {
      _values.clear(); // Clear stored inputs
      _resetKey++; // Change key to force widget rebuild
      _totalInputSum = 0; // Reset input sum
    });
  }

  // Handle pull-to-delete functionality
  Future<void> _onRefresh() async {
    _animationController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 500)); // Show icon animation
    _resetAll();
    _animationController.reverse(); // Hide the icon after reset
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = _values.entries.fold(0, (sum, entry) => sum + entry.key * entry.value);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Calculate", style: TextStyle(fontSize: 20, fontFamily: 'Parkinsans')),
        actions: [
          IconButton(
            onPressed: _resetAll, // Call save function
            icon: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.delete, size: 40),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.red,
            onRefresh: _onRefresh,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_animationController.value * 0.05), // subtle scale effect
                  child: child,
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: ScreenUtil.scaleH(120)),
                      child: Column(
                        children: _denominations.map((denomination) {
                          return CalculationRow(
                            key: ValueKey("$_resetKey-${denomination["value"]}"),
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
                      totalInputs: _totalInputSum,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Delete icon animation overlay
          Positioned(
            top: 16,
            child: FadeTransition(
              opacity: _animationController,
              child: ScaleTransition(
                scale: Tween(begin: 0.8, end: 1.2)
                    .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                  ),
                  child: const Icon(Icons.delete_forever, color: Colors.white, size: 36),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
