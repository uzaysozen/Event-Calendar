import 'package:countdown_app/screens/event_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("getTimeText", () {
    test('Time text test with 0 seconds duration', () {
      Duration d = Duration(seconds: 0);
      expect(getTimeText(d), "The event is over!");
    });
    test('Time text test with -1 seconds duration', () {
      Duration d = Duration(seconds: -1);
      expect(getTimeText(d), "The event is over!");
    });
    test('Time text test with 1 second duration', () {
      Duration d = Duration(seconds: 1);
      expect(getTimeText(d), "1 second");
    });
    test('Time text test with 2 seconds duration', () {
      Duration d = Duration(seconds: 2);
      expect(getTimeText(d), "2 seconds");
    });
    test('Time text test with minutes and seconds', () {
      Duration d = Duration(minutes: 4, seconds: 23);
      expect(getTimeText(d), "4 minutes 23 seconds");
    });
    test('Time text test with hours, minutes and seconds', () {
      Duration d = Duration(hours: 3, minutes: 4, seconds: 23);
      expect(getTimeText(d), "3 hours 4 minutes 23 seconds");
    });
    test('Time text test with days, hours, minutes and seconds', () {
      Duration d = Duration(days:12, hours: 3, minutes: 4, seconds: 23);
      expect(getTimeText(d), "12 days 3 hours 4 minutes 23 seconds");
    });
  });
}
