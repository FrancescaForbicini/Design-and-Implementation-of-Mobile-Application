import 'dart:async';

import 'package:dima_project/main.dart' as app;
import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('User Profile Test', ()  {
    testWidgets(
      'Best Quiz Test',
      (WidgetTester tester) async {
        await app.main();

        await tester.pumpAndSettle();

        await homeSteps(tester);

        await tester.tap(find.byKey(const Key('bestquiz_button')));

        await tester.pumpAndSettle();

        expect(
            find.byKey(const Key('bestquiz_page')), findsAtLeastNWidgets(1));

        await tester.tap(find.byKey(const Key('arrow_back')));

        await tester.pumpAndSettle();

        expect(
            find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));

        bool timerDone = false;
        Timer(const Duration(seconds: 5), () => timerDone = true);
        while (timerDone != true) {
          await tester.pump();
        }

        await signoutSteps(tester);
      },

    );

    testWidgets(
      'Rank Test',
      (WidgetTester tester) async {

        await app.main();

        await tester.pumpAndSettle();

        await homeSteps(tester);

        await tester.tap(find.byKey(const Key('rank_button')));

        await tester.pumpAndSettle();

        expect(
            find.byKey(const Key('rank_page')), findsAtLeastNWidgets(1));

        await tester.tap(find.byKey(const Key('localrank_button')));

        await tester.pumpAndSettle();

        expect(find.byKey(const Key('rank_page')), findsAtLeastNWidgets(1));

        await tester.tap(find.byKey(const Key('globalrank_button')));

        await tester.pumpAndSettle();

        expect(
            find.byKey(const Key('rank_page')), findsAtLeastNWidgets(1));

        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('arrow_back')));

        await tester.pumpAndSettle();


        expect(
            find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));
        bool timerDone = false;
        Timer(const Duration(seconds: 5), () => timerDone = true);
        while (timerDone != true) {
          await tester.pump();
        }

        await signoutSteps(tester);
      },
    );
  });
}
