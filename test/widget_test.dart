import 'package:countdown_app/screens/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Event list page has a title', (tester) async {
    await tester.pumpWidget(MaterialApp(home: EventList()));
    final titleFinder = find.text('Your Events');

    expect(titleFinder, findsOneWidget);
  });
}