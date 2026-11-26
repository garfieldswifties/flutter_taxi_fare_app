import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_taxi_fare_app/main.dart';
import 'package:flutter_taxi_fare_app/views/splash_screen_ui.dart';
import 'package:flutter_taxi_fare_app/views/taxi_fare_ui.dart';
import 'package:material_ui/material_ui.dart';

const warning = 'กรุณากรอกข้อมูลให้ครบถ้วน';
final fields = find.byType(TextField);
final calculate = find.widgetWithText(ElevatedButton, 'คำนวณค่าโดยสาร');
final reset = find.widgetWithText(ElevatedButton, 'ยกเลิก');

void setViewport(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Future<void> openForm(WidgetTester tester) async {
  setViewport(tester, const Size(412, 915));
  await tester.pumpWidget(const MaterialApp(home: TaxiFareUi()));
}

Future<void> enterInputs(
  WidgetTester tester,
  String distance,
  String minutes,
) async {
  await tester.enterText(fields.at(0), distance);
  await tester.enterText(fields.at(1), minutes);
  await tester.ensureVisible(calculate);
}

void main() {
  testWidgets('Splash waits 3 seconds and replaces its route', (tester) async {
    setViewport(tester, const Size(412, 915));
    await tester.pumpWidget(const FlutterTaxiFareApp());
    expect(find.byType(SplashScreenUi), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2999));
    expect(find.byType(TaxiFareUi), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(TaxiFareUi), findsOneWidget);
    expect(find.byType(SplashScreenUi, skipOffstage: false), findsNothing);
    expect(
      Navigator.of(tester.element(find.byType(TaxiFareUi))).canPop(),
      false,
    );
  });

  testWidgets('Calculates the Figma input, then reset clears both fields', (
    tester,
  ) async {
    await openForm(tester);
    expect(find.text('0.00'), findsOneWidget);
    await enterInputs(tester, '25', '7');
    await tester.tap(calculate);
    await tester.pumpAndSettle();
    expect(find.text('224.50'), findsOneWidget);
    expect(find.text('บาท'), findsOneWidget);

    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(fields.at(0)).controller!.text, isEmpty);
    expect(tester.widget<TextField>(fields.at(1)).controller!.text, isEmpty);
    expect(find.text('0.00'), findsOneWidget);
  });

  testWidgets(
    'Invalid resubmission keeps the prior total and reset hides warning',
    (tester) async {
      await openForm(tester);
      await enterInputs(tester, '2.5', '1.5');
      await tester.tap(calculate);
      await tester.pumpAndSettle();
      expect(find.text('49.25'), findsOneWidget);

      await enterInputs(tester, '2.5', '');
      await tester.tap(calculate);
      await tester.pumpAndSettle();
      expect(find.text(warning), findsOneWidget);
      expect(find.text('49.25'), findsOneWidget);

      await tester.tap(reset);
      await tester.pumpAndSettle();
      expect(find.text(warning), findsNothing);
      expect(find.text('0.00'), findsOneWidget);
    },
  );

  const invalidCases = [
    ('', ''),
    ('', '7'),
    ('25', ''),
    ('0', '7'),
    ('-1', '0'),
    ('1', '-1'),
    ('abc', '0'),
    ('1', 'abc'),
    ('NaN', '0'),
    ('1', 'NaN'),
    ('Infinity', '0'),
    ('1', 'Infinity'),
    ('1.2.3', '0'),
    ('1e2', '0'),
    ('   ', '0'),
  ];
  for (final (distance, minutes) in invalidCases) {
    testWidgets('Rejects distance "$distance" and minutes "$minutes"', (
      tester,
    ) async {
      await openForm(tester);
      await enterInputs(tester, distance, minutes);
      await tester.tap(calculate);
      await tester.pumpAndSettle();
      expect(find.text(warning), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });
  }

  testWidgets('Rejects a finite input that would overflow the total', (
    tester,
  ) async {
    await openForm(tester);
    await enterInputs(tester, '9' * 308, '0');
    await tester.tap(calculate);
    await tester.pumpAndSettle();
    expect(find.text(warning), findsOneWidget);
    expect(find.text('0.00'), findsOneWidget);
  });

  testWidgets('Displays large finite totals in fixed decimal format', (
    tester,
  ) async {
    await openForm(tester);
    await enterInputs(tester, '1', '1000000000000000000000');
    await tester.tap(calculate);
    await tester.pumpAndSettle();
    expect(find.text('3000000000000000000000.00'), findsOneWidget);
    expect(find.text(warning), findsNothing);
  });

  testWidgets(
    'A small viewport scrolls with a keyboard inset and handles Next and Done',
    (tester) async {
      setViewport(tester, const Size(320, 568));
      await tester.pumpWidget(const FlutterTaxiFareApp());
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();

      await tester.ensureVisible(fields.at(0));
      await tester.enterText(fields.at(0), '0.50');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      final trafficEditor = tester.widget<EditableText>(
        find.byType(EditableText).at(1),
      );
      expect(trafficEditor.focusNode.hasFocus, true);
      tester.testTextInput.enterText('2');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('41.00'));
      await tester.pumpAndSettle();
      expect(find.text('41.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
