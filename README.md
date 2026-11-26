# Taxi Fare Calculator

Taxi Fare Calculator เป็นแอป Flutter และ Dart สำหรับประมาณค่าโดยสารแท็กซี่จากระยะทางและเวลาที่รถติดตามอัตราในโจทย์รายวิชา

## ฟังก์ชันการทำงาน

- แสดงหน้าเปิดแอป 3 วินาทีก่อนเข้าสู่หน้าคำนวณ
- คำนวณค่าโดยสารจากระยะทางแบบขั้นบันไดและเวลาที่รถติด แสดงผลเป็นบาทสองตำแหน่ง
- แสดง SnackBar เมื่อข้อมูลไม่ครบหรือไม่ถูกต้อง และล้างค่าที่กรอกพร้อมคืนผลเป็น 0.00 บาทเมื่อกด **ยกเลิก**

## ภาพหน้าจอแอปพลิเคชัน

ภาพจาก Flutter Web ใน Chrome ขนาด 412 × 915 logical pixels ตามขนาดอ้างอิงโดยประมาณของ Samsung Galaxy S20 Ultra ใน Figma

| Splash | Taxi Fare |
| :---: | :---: |
| <img src="docs/screenshots/01-splash.png" alt="หน้าเปิด Taxi Fare Calculator" width="200"> | <img src="docs/screenshots/02-taxi-fare-empty.png" alt="หน้าคำนวณก่อนกรอกข้อมูล แสดง 0.00 บาท" width="200"> |

| แจ้งเตือนเมื่อกรอกไม่ครบ | ผลคำนวณ |
| :---: | :---: |
| <img src="docs/screenshots/03-taxi-fare-validation.png" alt="SnackBar สีแดงแจ้งให้กรอกข้อมูลครบถ้วน" width="200"> | <img src="docs/screenshots/04-taxi-fare-result.png" alt="ระยะทาง 25 กิโลเมตร รถติด 7 นาที ได้ 224.50 บาท" width="200"> |

## เทคโนโลยีที่ใช้

| เทคโนโลยี / Package | หน้าที่ |
| --- | --- |
| Flutter 3.50 และ Dart 3.14 | สร้างหน้าจอและเขียนตรรกะคำนวณ |
| `material_ui` 1.11.1 | ส่วนประกอบ Material สำหรับหน้าจอ |
| `flutter_test` และ `flutter_lints` 6.0.0 | ทดสอบและกำหนดกฎวิเคราะห์โค้ด |
| Kanit | ฟอนต์ที่ใช้แสดงข้อความในแอป |

## โครงสร้างโปรเจกต์

| ไฟล์ | Class | หน้าที่ |
| --- | --- | --- |
| `lib/main.dart` | `FlutterTaxiFareApp` | เรียกหน้าเปิดแอป |
| `lib/taxi_fare.dart` | — | ฟังก์ชัน `calculateTaxiFare` สำหรับคำนวณค่าระยะทางและเวลารถติด |
| `lib/views/splash_screen_ui.dart` | `SplashScreenUi` | แสดงหน้าเปิดแอป 3 วินาที แล้วเปิดหน้าคำนวณ |
| `lib/views/taxi_fare_ui.dart` | `TaxiFareUi` | รับค่า ตรวจข้อมูล แสดงผล และล้างข้อมูล |
| `test/` | — | ตรวจสูตรค่าโดยสารและการทำงานของหน้าจอ |
| `assets/`, `docs/screenshots/` | — | เก็บทรัพยากรของแอปและภาพประกอบ README |
| `android/`, `ios/`, `web/` | — | เก็บไฟล์ตั้งค่าของแต่ละแพลตฟอร์ม |

## การติดตั้งและใช้งาน

ใช้ Flutter SDK ที่รองรับ Dart `^3.14.0` ตาม `pubspec.yaml` เวอร์ชันที่ใช้ทดสอบคือ Flutter 3.50 ติดตั้ง Chrome แล้วรันคำสั่งจากโฟลเดอร์โปรเจกต์

```sh
flutter pub get
flutter run -d chrome
```

กรอกระยะทางมากกว่า 0 กิโลเมตร และเวลารถติดตั้งแต่ 0 นาที ทั้งสองช่องรับทศนิยมโดยใช้จุด จากนั้นกด **คำนวณค่าโดยสาร** แอปจะแจ้งเตือนหากข้อมูลไม่ถูกต้องหรือมีค่ามากเกินช่วงคำนวณ ปุ่ม **ยกเลิก** ล้างทั้งสองช่องและคืนผลเป็น 0.00 บาท

### วิธีคำนวณ

เริ่มที่ 35 บาทสำหรับระยะทางมากกว่า 0 ถึง 1 กม. คิดระยะทางส่วนที่เกินตามอัตราของแต่ละช่วง แล้วบวกเวลารถติดนาทีละ 3.00 บาท แสดงยอดรวมเป็นบาทสองตำแหน่ง

ระยะทางที่มากกว่า 0 แต่น้อยกว่า 1 กม. ใช้ค่าระยะทางขั้นต่ำ 35.00 บาท เพราะโจทย์ไม่ได้ระบุกรณีนี้โดยตรง

| ระยะทาง (กม.) | อัตรา |
| --- | ---: |
| มากกว่า 0 ถึง 1 | 35.00 บาท |
| มากกว่า 1 ถึง 10 | 6.50 บาท/กม. |
| มากกว่า 10 ถึง 20 | 7.00 บาท/กม. |
| มากกว่า 20 ถึง 40 | 8.00 บาท/กม. |
| มากกว่า 40 ถึง 60 | 8.50 บาท/กม. |
| มากกว่า 60 ถึง 80 | 9.00 บาท/กม. |
| มากกว่า 80 | 10.50 บาท/กม. |

ตัวอย่าง 25 กม. รถติด 7 นาที คิดเป็น `35 + 9 × 6.50 + 10 × 7.00 + 5 × 8.00 + 7 × 3.00 = 224.50` บาท ภาพตัวอย่างใน Figma แสดง 169.00 บาทสำหรับข้อมูลเดียวกัน แอปใช้อัตราที่ระบุบน [ตารางอัตราใน Figma](https://www.figma.com/design/QOtOM4iI0aLiIYD0JkBug2/Project--flutter_taxi_fare_app?node-id=2002-5)

## การทดสอบและข้อจำกัด

| รายการ | ผล |
| --- | --- |
| `flutter analyze` | ผ่าน |
| `flutter test` | ผ่าน 44/44 ครอบคลุมการคำนวณและการใช้งานหน้าจอ |
| Web build | สร้างสำเร็จ |
| Web runtime | มีภาพหน้าจอจาก Chrome |
| Android build | สร้าง debug APK สำเร็จ |
| Android runtime และ iOS | ยังไม่ได้ยืนยันผลการรัน |

## เครดิตและสิทธิ์การใช้งาน

### ทรัพยากรจากอาจารย์และ Figma

หน้าจอและอัตราค่าโดยสารอ้างอิง Figma ของรายวิชา [แบบหน้าจอและตารางค่าโดยสาร](https://www.figma.com/design/QOtOM4iI0aLiIYD0JkBug2/Project--flutter_taxi_fare_app?node-id=2002-5)

### Fonts, Packages และ Open-source Licenses

- **Kanit** โดย The Kanit Project Authors ใช้สัญญาอนุญาต SIL Open Font License 1.1 และเก็บไฟล์สัญญาอนุญาตไว้ในโปรเจกต์ [OFL.txt](assets/fonts/OFL.txt) · [Google Fonts](https://github.com/google/fonts/tree/main/ofl/kanit)
- **Flutter SDK และ flutter_test** โดย The Flutter Authors ใช้ BSD 3-Clause [Flutter LICENSE](https://github.com/flutter/flutter/blob/master/LICENSE)
- **material_ui 1.11.1** โดย The Flutter Authors ใช้ BSD 3-Clause [License ของเวอร์ชันที่ใช้](https://pub.dev/packages/material_ui/versions/1.11.1/license)
- **flutter_lints 6.0.0** โดย The Flutter Authors ใช้ BSD 3-Clause [License ของเวอร์ชันที่ใช้](https://pub.dev/packages/flutter_lints/versions/6.0.0/license)

### Third-party Assets และ Trademarks

ภาพ `assets/images/taxi.png` สร้างขึ้นสำหรับโปรเจกต์นี้ด้วย PowerShell และ .NET `System.Drawing` และใช้เป็นต้นทางของ launcher icons สำหรับ Android, iOS และ Web รวมถึง favicon

ข้อความ TAXI ในภาพใช้ Arial จากระบบตามเงื่อนไขของเจ้าของสิทธิ์ โปรเจกต์แจกจ่ายเฉพาะภาพที่เรนเดอร์แล้ว
