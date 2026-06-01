import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bar_time/main.dart';

void main() {
  testWidgets('shows bar time empty state', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MenuBookApp());
    await tester.pump();

    expect(find.text('Bar Time'), findsOneWidget);
    expect(find.text('No dishes yet'), findsOneWidget);
    expect(find.text('Add dish'), findsWidgets);

    await tester.tap(find.text('Cocktails'));
    await tester.pump();

    expect(find.text('Cocktails'), findsWidgets);
    expect(find.text('No cocktails yet'), findsOneWidget);
    expect(find.text('Add cocktail'), findsWidgets);

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(find.text('Bar Calendar'), findsOneWidget);
    expect(
        find.textContaining(RegExp(
            r'January|February|March|April|May|June|July|August|September|October|November|December')),
        findsOneWidget);
    expect(find.text('S'), findsWidgets);
    expect(find.byTooltip('Add footprint'), findsWidgets);
  });
}
