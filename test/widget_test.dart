import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery/main.dart';
import 'package:grocery/services/grocery_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home screen shows grocery lists title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = GroceryStorage(await SharedPreferences.getInstance());

    await tester.pumpWidget(GroceryApp(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('Grocery lists'), findsOneWidget);
    expect(find.text('New list'), findsOneWidget);
  });
}
