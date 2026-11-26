import 'package:material_ui/material_ui.dart';

import 'taxi_fare_ui.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    openTaxiFare();
  }

  // เปิดหน้าคำนวณหลังจากแสดง Splash และแทนที่เส้นทางเดิม
  Future<void> openTaxiFare() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => const TaxiFareUi()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF64B5F6);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/taxi.png', width: 200, height: 160),
                const SizedBox(height: 40),
                const Text(
                  'Taxi Fare Calculator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'คำนวณค่าโดยสารแท็กซี่',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: titleColor, fontSize: 20),
                ),
                const SizedBox(height: 28),
                const SizedBox.square(
                  dimension: 40,
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                    strokeWidth: 4,
                    semanticsLabel: 'กำลังเปิดหน้าคำนวณ',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
