import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('create an event, test event list screen',
            (tester) async {
          app.main();
          await tester.pumpAndSettle();

          expect(find.text('Your Events'), findsOneWidget);
          
          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();
          expect(find.text('Create New Event'), findsOneWidget);
          await tester.enterText(find.byKey(Key("Event Add Name Field")), 'TEST');
          await tester.enterText(find.byKey(Key("Event Add Description Field")), 'TEST');
          final dateButton = find.text('Choose a Date For the Event');
          //final timeButton = find.text('Choose a Time For the Event');
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(dateButton);
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(find.text('15'));
          await tester.tap(find.text('OK'));
          //await tester.tap(timeButton);
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(find.byKey(Key("Event Add Save Button")));
          await tester.pumpAndSettle(Duration(seconds: 3));
          expect(find.text('TEST'), findsOneWidget);

        });
    testWidgets('update an event, test detail screen',
            (tester) async {
          app.main();
          await tester.pumpAndSettle(Duration(seconds: 3));

          expect(find.text('TEST'), findsOneWidget);

          await tester.tap(find.text("TEST"));
          await tester.pumpAndSettle(Duration(seconds: 3));
          expect(find.text('Event Detail: TEST'), findsOneWidget);
          final Finder nameField = find.byKey(Key("Event Detail Name Field"));
          final Finder descriptionField = find.byKey(Key("Event Detail Description Field"));
          await tester.tap(nameField);
          await tester.pumpAndSettle(Duration(seconds: 1));
          await tester.enterText(nameField, 'Update Test');
          await tester.tap(descriptionField);
          await tester.pumpAndSettle(Duration(seconds: 1));
          await tester.enterText(descriptionField, 'Update Test');
          final dateButton = find.text('Choose a Date For the Event');
          //final timeButton = find.text('Choose a Time For the Event');
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(dateButton);
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(find.text('18'));
          await tester.tap(find.text('OK'));
          //await tester.tap(timeButton);
          await tester.pumpAndSettle(Duration(seconds: 3));
          await tester.tap(find.byKey(Key("Update Button")));
          await tester.pumpAndSettle(Duration(seconds: 3));
          expect(find.text('Update Test'), findsOneWidget);

        });
    testWidgets('delete an event, test detail screen',
            (tester) async {
              app.main();
              await tester.pumpAndSettle(Duration(seconds: 3));

              expect(find.text('Update Test'), findsOneWidget);

              await tester.tap(find.text("Update Test"));
              //await tester.tap(timeButton);
              await tester.pumpAndSettle(Duration(seconds: 3));
              await tester.tap(find.byKey(Key("Delete Button")));
              await tester.pumpAndSettle(Duration(seconds: 3));
              expect(find.text('Update Test'), findsNothing);
        });
  });
}