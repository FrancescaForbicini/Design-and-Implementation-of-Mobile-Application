import 'package:dima_project/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'utils.dart';
import 'package:flutter/material.dart';

void main() {
  int numberRightQuestion = 3;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Quiz test', () {
    testWidgets('Question Playlist Test', (WidgetTester tester) async {

      await app.main();

      await tester.pumpAndSettle();

      await userProfileSteps(tester);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_button')));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      await quizSteps(tester,numberRightQuestion);
    });

    testWidgets('Question Artist Test', (WidgetTester tester) async {

      await app.main();

      await tester.pumpAndSettle();

      await userProfileSteps(tester);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_button')));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('artist_button2')));

      await quizSteps(tester,numberRightQuestion);
    });
  });
}
