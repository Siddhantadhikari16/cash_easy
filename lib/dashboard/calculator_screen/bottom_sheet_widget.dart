import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for formatting
import 'package:auto_size_text/auto_size_text.dart';
import '../../screen_util.dart';

class BottomSheetWidget extends StatelessWidget {
  final int totalAmount;
  final int totalInputs; // Sum of text field values

  const BottomSheetWidget({Key? key, required this.totalAmount, required this.totalInputs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedAmount = NumberFormat.decimalPattern('en_IN').format(totalAmount);
    String formattedInputs = NumberFormat.decimalPattern('en_IN').format(totalInputs);

    return Container(
      padding: EdgeInsets.all(ScreenUtil.scaleW(16)), // Responsive padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade700, Colors.teal.shade300],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(ScreenUtil.scaleW(20))),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: ScreenUtil.scaleW(12), spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil.scaleH(5)),
                child: AutoSizeText(
                  "Total: ₹ $formattedAmount",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  minFontSize: 1,
                  maxFontSize: 24,
                ),
              ),
              SizedBox(height: ScreenUtil.scaleW(8)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil.scaleH(5)),
                child: AutoSizeText(
                  "Total Notes: $formattedInputs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  minFontSize: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}