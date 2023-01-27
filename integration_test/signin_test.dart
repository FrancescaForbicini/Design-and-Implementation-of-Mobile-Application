import 'dart:async';

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
        'Sign in test',
            (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();

          await loginSteps(tester);

          await tester.pumpAndSettle();

          expect(find.byKey(const Key('spoty_webview')), findsAtLeastNWidgets(1));
        },
      );
    },
  );
}