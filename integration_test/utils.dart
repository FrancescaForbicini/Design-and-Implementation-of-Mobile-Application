import 'dart:async';

import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final bool found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> pumpUntilNotFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final bool found = tester.any(finder);
    if (!found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> waitForNSeconds(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
  }
  timer.cancel();
}

const Map<String, String> testingAccount = {
  'email': 'test@dima.com',
  'password': 'Test99!'
};

Future<void> loginSteps(
  WidgetTester tester,
) async {

  isTest = true;

  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('sign_in_button')));

  await tester.pumpAndSettle();

  await tester.enterText(
      find.byKey(const Key('email_text_input')), testingAccount['email']!);

  await tester.pumpAndSettle();

  await tester.testTextInput.receiveAction(TextInputAction.done);

  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const Key('password_text_input')),
      testingAccount['password']!);

  await tester.pumpAndSettle();

  await tester.testTextInput.receiveAction(TextInputAction.done);

  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('sign_in_button')));


  await pumpUntilFound(
    tester,
    find.byKey(const Key('spoty_webview')),
  );

  bool timerDone = false;
  Timer(const Duration(seconds: 5), () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
  }
}

Future<void> homeSteps(WidgetTester tester) async {
  await tester.pumpAndSettle();

  await loginSteps(tester);

  expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

  await tester.tap(find.byKey(const Key('user_button')));

  await tester.pumpAndSettle();

  expect(find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));
  await tester.pumpAndSettle();
}
