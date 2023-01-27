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

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('playlist_button2')));

      await quizSteps(tester,numberRightQuestion);
    });

    testWidgets('Question Artist Test', (WidgetTester tester) async {

      await app.main();

      await loadingHomeSteps(tester);

      expect(find.byKey(const Key('home_page')), findsAtLeastNWidgets(1));

      await tester.tap(find.byKey(const Key('artist_button2')));

      await quizSteps(tester,numberRightQuestion);
    });
  });
}
