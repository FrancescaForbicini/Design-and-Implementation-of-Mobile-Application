import 'dart:async';

import 'package:dima_project/main.dart' as app;
import 'package:dima_project/screens/quiz/result_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'utils.dart';
import 'package:flutter/material.dart';

void main() {
  int numberRightQuestion;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Result Page test', () {

    testWidgets('Bad Result Test', (WidgetTester tester) async {

      numberRightQuestion = 0;

      isTest = true;

      await app.main();

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      await quizSteps(tester, numberRightQuestion);

      /*await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('exit_button')));

      await tester.pumpAndSettle();*/

      expect(
          find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));


      await signOutSteps(tester);
    });

    testWidgets('Best Result Test', (WidgetTester tester) async {

      isTest = true;

      numberRightQuestion = 1;

      await app.main();

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      /*await quizSteps(tester, numberRightQuestion);*/

      await pumpUntilFound(
        tester,
        find.byKey(const Key('quiz_load')),
      );

      await pumpUntilFound(
        tester,
        find.byKey(const Key('quiz_builder')),
      );

      for (int i = 0; i < numberRightQuestion; i++) {
        expect(find.byKey(const Key('rightAnswer')), findsAtLeastNWidgets(1));

        await tester.tap(find.byKey(const Key('rightAnswer')));

        await tester.pumpAndSettle();
      }

      expect(find.byKey(const Key('wrongAnswer1')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('wrongAnswer1')));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('result_page')), findsAtLeastNWidgets(1));

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera_button')));

      //TODO

      await tester.pumpAndSettle();


      await tester.tap(find.byKey(const Key('location_button')));

      //TODO

      await tester.pumpAndSettle();

      bool timerDone = false;
      Timer(const Duration(seconds: 5), () => timerDone = true);
      while (timerDone != true) {
        await tester.pump();
      }

      expect(find.byKey(const Key('exit_button')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('exit_button')));

      await tester.pumpAndSettle();

      expect(
          find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));


      await signOutSteps(tester);
    });
  });
}
