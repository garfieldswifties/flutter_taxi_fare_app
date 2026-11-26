# Taxi Fare Calculator

Assignment 05 ฝึกสร้างแอป Flutter และ Dart สำหรับคำนวณค่าโดยสารแท็กซี่จากระยะทางและเวลารถติด โปรเจกต์ชื่อ `flutter_taxi_fare_app` รองรับโครงสร้าง Android, iOS และ Web

## ภาพหน้าจอ

ภาพจากแอปใน Chrome แบบเบื้องหลังที่ขนาด 412 × 915 logical pixels ตามขนาดอ้างอิงโดยประมาณของ Samsung Galaxy S20 Ultra ใน Figma

| Splash | Taxi Fare |
| :---: | :---: |
| <img src="docs/screenshots/01-splash.png" alt="หน้าเปิด Taxi Fare Calculator" width="200"> | <img src="docs/screenshots/02-taxi-fare-empty.png" alt="หน้าคำนวณก่อนกรอกข้อมูล แสดง 0.00 บาท" width="200"> |

| แจ้งเตือนเมื่อกรอกไม่ครบ | ผลคำนวณ |
| :---: | :---: |
| <img src="docs/screenshots/03-taxi-fare-validation.png" alt="SnackBar สีแดงแจ้งให้กรอกข้อมูลครบถ้วน" width="200"> | <img src="docs/screenshots/04-taxi-fare-result.png" alt="ระยะทาง 25 กิโลเมตร รถติด 7 นาที ได้ 224.50 บาท" width="200"> |

## ไฟล์หน้าจอ

| ไฟล์ใน `lib/views/` | Class | หน้าที่ |
| --- | --- | --- |
| `splash_screen_ui.dart` | `SplashScreenUi` | แสดงหน้าเปิดแอป 3 วินาที แล้วเปิดหน้าคำนวณ |
| `taxi_fare_ui.dart` | `TaxiFareUi` | รับค่า ตรวจข้อมูล แสดงผล และล้างข้อมูล |

## วิธีทดลอง

เปิด Terminal ที่โฟลเดอร์โปรเจกต์ด้วย Flutter 3.50 และ Dart 3.14 แล้วรัน

```sh
flutter pub get
flutter run -d chrome
```

กรอกระยะทางมากกว่า 0 กิโลเมตร และเวลารถติดตั้งแต่ 0 นาที ใช้จุดสำหรับทศนิยม แล้วกด **คำนวณค่าโดยสาร** เมื่อข้อมูลไม่ถูกต้อง แอปแสดง SnackBar ปุ่ม **ยกเลิก** ล้างทั้งสองช่องและคืนผลเป็น 0.00 บาท

## วิธีคำนวณ

เริ่มที่ 35 บาทสำหรับระยะทางมากกว่า 0 ถึง 1 กม. คิดระยะทางส่วนที่เกินตามอัตราของแต่ละช่วง แล้วบวกเวลารถติดนาทีละ 3.00 บาท แสดงยอดรวมเป็นบาทสองตำแหน่ง

สำหรับระยะทางมากกว่า 0 แต่น้อยกว่า 1 กม. ผู้จัดทำเลือกคิดค่าโดยสารส่วนระยะทางขั้นต่ำ 35.00 บาท เนื่องจากโจทย์ไม่ได้ระบุวิธีคิดกรณีนี้ไว้อย่างชัดเจน

| ระยะทาง (กม.) | อัตรา |
| --- | ---: |
| มากกว่า 0 ถึง 1 | 35.00 บาท |
| มากกว่า 1 ถึง 10 | 6.50 บาท/กม. |
| มากกว่า 10 ถึง 20 | 7.00 บาท/กม. |
| มากกว่า 20 ถึง 40 | 8.00 บาท/กม. |
| มากกว่า 40 ถึง 60 | 8.50 บาท/กม. |
| มากกว่า 60 ถึง 80 | 9.00 บาท/กม. |
| มากกว่า 80 | 10.50 บาท/กม. |

ตัวอย่าง 25 กม. รถติด 7 นาที คิดเป็น `35 + 9 × 6.50 + 10 × 7.00 + 5 × 8.00 + 7 × 3.00 = 224.50` บาท ภาพตัวอย่างใน Figma แสดง 169.00 บาทสำหรับข้อมูลเดียวกัน แอปใช้อัตราที่ระบุบน [บอร์ด Figma ของ Assignment 05](https://www.figma.com/design/QOtOM4iI0aLiIYD0JkBug2/Project--flutter_taxi_fare_app?node-id=2002-5)

## การตรวจสอบ

```sh
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
flutter build apk --debug
```

## เครดิตและสิทธิ์การใช้งาน

### ทรัพยากรจากอาจารย์

ใช้บอร์ด Figma ของอาจารย์อ้างอิงหน้าจอและตารางค่าโดยสาร เมื่อวันที่ 26 พฤศจิกายน 2569 อาจารย์อนุญาตให้นำทรัพยากรที่ให้มาเผยแพร่บน Public GitHub เพื่อส่งงานรายวิชา ลิขสิทธิ์ยังเป็นของเจ้าของเดิม และเงื่อนไขของเจ้าของสิทธิ์ภายนอกยังมีผล [บอร์ด Assignment 05](https://www.figma.com/design/QOtOM4iI0aLiIYD0JkBug2/Project--flutter_taxi_fare_app?node-id=2002-5)

### Fonts และ Packages

- **Kanit** โดย The Kanit Project Authors ใช้สัญญาอนุญาต SIL Open Font License 1.1 และเก็บไฟล์สัญญาอนุญาตไว้ในโปรเจกต์ [OFL.txt](assets/fonts/OFL.txt) · [Google Fonts](https://github.com/google/fonts/tree/main/ofl/kanit)
- **Flutter SDK และ flutter_test** โดย The Flutter Authors ใช้ BSD 3-Clause [Flutter LICENSE](https://github.com/flutter/flutter/blob/master/LICENSE)
- **material_ui 1.11.1** โดย The Flutter Authors ใช้ BSD 3-Clause [License ของเวอร์ชันที่ใช้](https://pub.dev/packages/material_ui/versions/1.11.1/license)
- **flutter_lints 6.0.0** โดย The Flutter Authors ใช้ BSD 3-Clause [License ของเวอร์ชันที่ใช้](https://pub.dev/packages/flutter_lints/versions/6.0.0/license)

### ภาพประกอบและไอคอน

ภาพ `assets/images/taxi.png` วาดขึ้นสำหรับ Assignment นี้ด้วยสคริปต์ PowerShell และ .NET `System.Drawing` โดยประกอบจากรูปทรง เส้นโค้ง และข้อความ TAXI ที่เรนเดอร์ด้วย Arial จากระบบ สคริปต์เดียวกันใช้ภาพนี้สร้าง launcher icons สำหรับ Android, iOS และ Web รวมถึง favicon ไฟล์ฟอนต์ Arial ไม่ได้รวมในโปรเจกต์
