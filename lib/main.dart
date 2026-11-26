// นำเข้า Flutter และหน้าเปิดแอป
import 'package:material_ui/material_ui.dart';

import 'views/splash_screen_ui.dart';

// เริ่มต้นแอป
void main() {
  runApp(const FlutterTaxiFareApp());
}

class FlutterTaxiFareApp extends StatelessWidget {
  const FlutterTaxiFareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Fare Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: const Color(0xFFFEF7FF),
      ),
      home: const SplashScreenUi(),
    );
  }
}
