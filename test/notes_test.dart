import 'package:capture_costs_for_household/components/notizen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Test Note Screen Widget', () {
    testWidgets('Everything should be loaded', (tester) async {
      databaseFactory = databaseFactoryFfi;
      await tester.pumpWidget(
        const MaterialApp(
          home: NotizenSeite(),
        ),
      );
      var scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);
      var scaffold = tester.widget<Scaffold>(scaffoldFinder);

      expect((scaffold.appBar as AppBar).title?.toStringDeep(), const Text(
        "Meine Notizen",
        style: TextStyle(fontSize: 28),
      ).toStringDeep());

      print((scaffold.floatingActionButton as FloatingActionButton).onPressed);
      expect(scaffold.body?.toStringDeep(), ListView().toStringDeep());
      // await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    });
  });
}
