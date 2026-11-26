import 'package:material_ui/material_ui.dart';

import '../taxi_fare.dart';

class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  // ตัวควบคุมช่องกรอกและผลค่าโดยสาร
  final distanceController = TextEditingController();
  final trafficController = TextEditingController();
  final decimalPattern = RegExp(r'^-?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$');
  double fare = 0.0;

  @override
  void dispose() {
    distanceController.dispose();
    trafficController.dispose();
    super.dispose();
  }

  double? readNumber(TextEditingController controller) {
    final text = controller.text.trim();
    if (!decimalPattern.hasMatch(text)) return null;

    final number = double.tryParse(text);
    if (number == null || !number.isFinite) return null;
    return number;
  }

  void calculateFare() {
    FocusScope.of(context).unfocus();
    final distance = readNumber(distanceController);
    final minutes = readNumber(trafficController);
    if (distance == null || distance <= 0 || minutes == null || minutes < 0) {
      showInputWarning();
      return;
    }

    final total = calculateTaxiFare(distance, minutes);
    if (!total.isFinite) {
      showInputWarning();
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => fare = total);
  }

  void showInputWarning() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.amber),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'กรุณากรอกข้อมูลให้ครบถ้วน',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void resetFare() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    distanceController.clear();
    trafficController.clear();
    setState(() => fare = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final fareText = fare < 1e21
        ? fare.toStringAsFixed(2)
        : '${BigInt.from(fare)}.00';

    return Scaffold(
      // แถบชื่อหน้า
      appBar: AppBar(
        title: const Text('Taxi Fare', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 24.0 : 40.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                60,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 332),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/taxi.png',
                          width: 200,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 39),
                      const Text(
                        'คำนวณค่าโดยสารแท็กซี่',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ช่องกรอกระยะทางและเวลารถติด
                      fareInput(
                        label: 'ระยะทาง (กิโลเมตร) 🛣️',
                        hint: 'กรุณากรอกระยะทาง',
                        controller: distanceController,
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 18),
                      fareInput(
                        label: 'เวลารถติด (นาที) ⏰',
                        hint: 'กรุณากรอกเวลารถติด',
                        controller: trafficController,
                        action: TextInputAction.done,
                        onSubmitted: (_) => calculateFare(),
                      ),
                      const SizedBox(height: 30),
                      fareButton(
                        label: 'คำนวณค่าโดยสาร',
                        color: Colors.amber,
                        onPressed: calculateFare,
                      ),
                      const SizedBox(height: 15),
                      fareButton(
                        label: 'ยกเลิก',
                        color: Colors.grey,
                        onPressed: resetFare,
                      ),
                      const SizedBox(height: 15),
                      // ผลค่าโดยสารพร้อมหน่วย
                      Semantics(
                        liveRegion: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'ค่าโดยสารแท็กซี่',
                                style: TextStyle(fontSize: 20, height: 1.4),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  fareText,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 36,
                                    height: 1.45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Text(
                                'บาท',
                                style: TextStyle(fontSize: 20, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget fareInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputAction action,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            height: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: action,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            constraints: const BoxConstraints(minHeight: 60),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget fareButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
