import 'dart:math';

// คิดอัตราเฉพาะระยะทางที่วิ่งในแต่ละช่วง แล้วบวกเวลารถติด
double calculateTaxiFare(double distance, double trafficMinutes) {
  double fare = 35.0;
  if (distance > 1) fare += (min(distance, 10) - 1) * 6.50;
  if (distance > 10) fare += (min(distance, 20) - 10) * 7.00;
  if (distance > 20) fare += (min(distance, 40) - 20) * 8.00;
  if (distance > 40) fare += (min(distance, 60) - 40) * 8.50;
  if (distance > 60) fare += (min(distance, 80) - 60) * 9.00;
  if (distance > 80) fare += (distance - 80) * 10.50;

  return fare + trafficMinutes * 3.00;
}
