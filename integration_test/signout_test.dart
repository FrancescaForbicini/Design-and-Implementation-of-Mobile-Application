import 'dart:math';

import 'package:dima_project/main.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('authentication test', () {
    testWidgets(
      'Sign out test',
      (WidgetTester tester) async {
        await app.main();

        await tester.pumpAndSettle();
        await loginSteps(tester);

        print("Done loginSteps");

        //await tester.pumpAndSettle();

        print("Almost in expect");

        expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

        await tester.pump();

        await signoutSteps(tester);

        expect(
            find.byKey(const Key('auth_container')), findsAtLeastNWidgets(1));
      },
    );
  });
}
