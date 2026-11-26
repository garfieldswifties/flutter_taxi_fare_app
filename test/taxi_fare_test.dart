import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_taxi_fare_app/taxi_fare.dart';

void main() {
  // ผลคาดหวังคำนวณด้วยมือจากตารางอัตราบนบอร์ด
  const cases = <(double, double, String)>[
    (0.01, 0, '35.00'),
    (0.50, 2, '41.00'),
    (0.75, 0, '35.00'),
    (1, 0, '35.00'),
    (1.25, 0, '36.63'),
    (2.50, 1.50, '49.25'),
    (9.75, 0, '91.88'),
    (10, 0, '93.50'),
    (10.25, 0, '95.25'),
    (19.75, 0, '161.75'),
    (20, 0, '163.50'),
    (20.25, 0, '165.50'),
    (25, 7, '224.50'),
    (39.75, 0, '321.50'),
    (40, 0, '323.50'),
    (40.25, 0, '325.63'),
    (59.75, 0, '491.38'),
    (60, 0, '493.50'),
    (60.25, 0, '495.75'),
    (79.75, 0, '671.25'),
    (80, 0, '673.50'),
    (80.25, 0, '676.13'),
    (100, 10, '913.50'),
  ];

  for (final (distance, minutes, expected) in cases) {
    test('$distance km + $minutes min = $expected baht', () {
      final actual = calculateTaxiFare(distance, minutes).toStringAsFixed(2);
      printOnFailure('Expected $expected baht, actual $actual baht');
      expect(actual, expected);
    });
  }
}
