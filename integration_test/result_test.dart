import 'package:dima_project/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'utils.dart';
import 'package:flutter/material.dart';

void main() {
  int numberRightQuestion;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Result Page test', () {

    testWidgets('Bad Result Test', (WidgetTester tester) async {

      numberRightQuestion = 1;

      await app.main();

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      await quizSteps(tester, numberRightQuestion);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('exit_button')));

      await tester.pumpAndSettle();

      expect(
          find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));


      await signOutSteps(tester);
    });

    testWidgets('Best Result Test', (WidgetTester tester) async {

      numberRightQuestion = 1;

      await app.main();

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      await quizSteps(tester, numberRightQuestion);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera_button')));

      //TODO

      await tester.pumpAndSettle();


      await tester.tap(find.byKey(const Key('position_button')));

      //TODO

      await tester.pumpAndSettle();



      expect(find.byKey(const Key('exit_button')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('exit_button')));

      await tester.pumpAndSettle();

      expect(
          find.byKey(const Key('userprofile_page')), findsAtLeastNWidgets(1));


      await signOutSteps(tester);
    });
  });
}
