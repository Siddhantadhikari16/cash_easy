import 'dart:async';
import 'package:cash_easy/image_constants.dart';
import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'screen_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive sizing
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Center vertically
          children: [
            Image.asset(
              ImageConstants.logo,
              width: ScreenUtil.scaleW(150), // Responsive logo size
              height: ScreenUtil.scaleH(150),
            ),
            SizedBox(height: ScreenUtil.scaleH(20)), // Spacing
            Text(
              "Cash Easy",
              style: TextStyle(
                fontSize: ScreenUtil.scaleFont(30), // Responsive text size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
