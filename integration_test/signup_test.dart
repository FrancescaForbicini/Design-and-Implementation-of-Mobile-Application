import 'dart:math';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'authentication test',
        () {
      testWidgets(
        'Sign up test',
            (WidgetTester tester) async {
          await app.main();

          await tester.pumpAndSettle();

          final signUpButton = find.byKey(const Key('sign_up_button'));

          expect(signUpButton, findsOneWidget);

          await tester.tap(signUpButton);

          await tester.pumpAndSettle();

          final emailTextInput = find.byKey(const Key('email_text_input'));
          final passwordTextInput = find.byKey(const Key('password_text_input'));
          final confpassTextInput = find.byKey(const Key('confpass_text_input'));
          final usernameTextInput = find.byKey(const Key('username_text_input'));

          await tester.enterText(
              emailTextInput, 'test${Random().nextDouble()}@gmail.com');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(passwordTextInput, 'Test1234');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(confpassTextInput, 'Test1234');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.enterText(usernameTextInput, 'test${Random().nextDouble()}');

          await tester.pumpAndSettle();

          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('sign_up_button')));

          await pumpUntilFound(
            tester,
            find.byKey(const Key('signup_ok_dialog')),
          );

          expect(find.byKey(const Key('signup_ok_dialog')), findsAtLeastNWidgets(1));
        },
      );
    },
  );
}