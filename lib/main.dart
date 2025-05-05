import 'package:cash_easy/screen_util.dart';
import 'package:cash_easy/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart'; // Import your generated Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding for platform services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable persistence settings (Optional)
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Force portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {



    runApp(const CashEasy()); // Your app's main widget
  });
}


class CashEasy extends StatefulWidget {
  const CashEasy({super.key});

  @override
  State<CashEasy> createState() => _CashEasyState();
}



class _CashEasyState extends State<CashEasy> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Builder(
          builder: (context) {
            ScreenUtil.init(context); // Initialize ScreenUtil for responsiveness

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Cash Easy",
              theme: ThemeData(
                primaryColor: CupertinoColors.activeBlue,
                secondaryHeaderColor: Colors.white,
                fontFamily: 'Parkinsans',
                appBarTheme: const AppBarTheme(
                  backgroundColor: CupertinoColors.activeBlue,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
