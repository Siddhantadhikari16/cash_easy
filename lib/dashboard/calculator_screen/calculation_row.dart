import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for input formatters
import 'package:intl/intl.dart'; // Import intl package for formatting
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import '../../screen_util.dart';

class CalculationRow extends StatefulWidget {
  final String imagePath;
  final int fixedValue;
  final Function(int, int)? onValueChanged; // Callback function (optional)

  const CalculationRow({
    Key? key,
    required this.imagePath,
    required this.fixedValue,
    this.onValueChanged, // Callback to update parent widget
  }) : super(key: key);

  @override
  _CalculationRowState createState() => _CalculationRowState();
}

class _CalculationRowState extends State<CalculationRow> {
  final TextEditingController _controller = TextEditingController();
  int result = 0;

  void _calculateResult(String value) {
    int userInput = int.tryParse(value) ?? 0;
    int newResult = widget.fixedValue * userInput;

    if (newResult != result) {
      // Prevent unnecessary rebuilds
      setState(() {
        result = newResult;
      });

      if (widget.onValueChanged != null) {
        widget.onValueChanged!(widget.fixedValue, userInput);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedResult = NumberFormat.decimalPattern('en_IN').format(result);

    return Card(
      color: Colors.white70,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil.scaleW(8),
        vertical: ScreenUtil.scaleH(5),
      ), // Reduced margin
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil.scaleW(6), horizontal: ScreenUtil.scaleW(5)), // Reduced padding
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(widget.imagePath,
                    height: ScreenUtil.scaleH(16)), // Reduced image size
                SizedBox(height: ScreenUtil.scaleH(4)), // Reduced spacing
                Text(
                  "₹${widget.fixedValue}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil.scaleFont(14), // Reduced font size
                  ),
                ),
              ],
            ),
            SizedBox(width: ScreenUtil.scaleW(6)), // Reduced spacing
            const Icon(CupertinoIcons.multiply, size: 18), // Reduced icon size
            SizedBox(width: ScreenUtil.scaleW(6)), // Reduced spacing
            SizedBox(
              width: ScreenUtil.scaleW(110), // Reduced width of TextField
              child: AutoSizeTextField(
                style: TextStyle(fontSize: ScreenUtil.scaleFont(16)), // Reduced font size
                controller: _controller,
                keyboardType: TextInputType.number,
                cursorColor: Colors.teal,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                  LengthLimitingTextInputFormatter(10),   // Limit input to 10 digits
                ],
                textAlign: TextAlign.center, // Center the cursor and input text
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ScreenUtil.scaleW(12)), // Reduced border radius
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(ScreenUtil.scaleW(12)),
                  ),
                ),
                onChanged: _calculateResult,
              ),
            ),
            SizedBox(width: ScreenUtil.scaleW(6)), // Reduced spacing
            const Icon(CupertinoIcons.equal, size: 18), // Reduced icon size
            SizedBox(width: ScreenUtil.scaleW(2)), // Reduced spacing
            Container(
              height: ScreenUtil.scaleH(35), // Reduced height
              width: ScreenUtil.scaleW(100), // Reduced width of result container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    ScreenUtil.scaleW(8)), // Reduced border radius
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0), // Reduced padding
                child: AutoSizeText(
                  "₹$formattedResult", // Formatted result with commas
                  style: TextStyle(
                    fontSize: ScreenUtil.scaleFont(16), // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
