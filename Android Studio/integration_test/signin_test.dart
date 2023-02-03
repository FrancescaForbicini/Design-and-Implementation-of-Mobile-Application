import 'dart:async';

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
          await loginSteps(tester);

          print("Done loginSteps");

          //await tester.pumpAndSettle();

          print("Almost in expect");

          expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

          await signOutSteps(tester);
        },
      );

      testWidgets(
        'Sign in error',
        (WidgetTester tester) async {
          await app.main();

          await tester.pumpAndSettle();

          isTest = true;

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await tester.pumpAndSettle();

          await tester.enterText(
              find.byKey(const Key('email_text_input')), 'test@dima.com');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(find.byKey(const Key('password_text_input')),
              'test');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_in_button')));

          await pumpUntilFound(
            tester,
            find.byKey(const Key('sign_in_err')),
          );

          expect(find.byKey(const Key('sign_in_err')), findsAtLeastNWidgets(1));
        },
      );
    }
  );
}
