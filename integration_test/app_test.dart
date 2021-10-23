// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:team_wins/main.dart' as app;
import 'package:team_wins/ui/winning_team.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('load and wait for results to display',
        (WidgetTester tester) async {
      app.main();

      await tester.pump();

      // Expect the loading indicator to display
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // the loading should have ended now
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // verify that team crest is displayed
      expect(find.byType(TeamCrest), findsOneWidget);
    });
  });
}
