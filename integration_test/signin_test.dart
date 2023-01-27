import 'package:dima_project/main.dart' as app;
import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'utils.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
    'authentication test',
    () {
      testWidgets(
        'Sign in test',
        (WidgetTester tester) async {
          await app.main();

          await tester.pumpAndSettle();
          isTest = true;
          await loginSteps(tester);

          print("Done loginSteps");

          //await tester.pumpAndSettle();

          print("Almost in expect");

          expect(find.byKey(const Key('home_scaffold')), findsAtLeastNWidgets(1));
        },
      );
    }
  );
}
