import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_wins/data_models.dart';
import 'package:team_wins/ui/winning_team.dart';
import 'package:team_wins/ui/winning_team_provider.dart';

import 'http_overrides.dart';
import 'response_data.dart';

void main() {
  group("WinningTeam", () {
    final Team teamOverride = Team.fromJson(TEAM_1);

    Widget buildApp(Widget home) {
      return ProviderScope(
        child: MaterialApp(home: home),
        overrides: [
          winningTeamProvider(2003)
              .overrideWithValue(AsyncValue.data(teamOverride)),
          winningTeamProvider(2004)
              .overrideWithValue(AsyncValue.error(Exception('Something'))),
        ],
      );
    }

    setUp(() {
      io.HttpOverrides.global = TestHttpOverrides();
    });

    testWidgets("team name shows", (tester) async {
      final app = buildApp(WinningTeam(competitionId: 2003));
      await tester.pumpWidget(app);
      final view = find.byType(WinningTeam);
      expect(view, findsOneWidget);

      final teamName = find.textContaining(teamOverride.name!);
      expect(teamName, findsOneWidget);
    });

    testWidgets("team address shows", (tester) async {
      final app = buildApp(WinningTeam(competitionId: 2003));
      await tester.pumpWidget(app);
      final view = find.byType(WinningTeam);
      expect(view, findsOneWidget);

      final teamAddress = find.text(teamOverride.address!);
      expect(teamAddress, findsOneWidget);
    });

    testWidgets("shows error message on error", (tester) async {
      final app = buildApp(WinningTeam(competitionId: 2004));
      await tester.pumpWidget(app);
      final view = find.byType(WinningTeam);
      expect(view, findsOneWidget);

      final teamAddress = find.text(teamOverride.address!);
      expect(teamAddress, findsNothing);

      expect(find.textContaining('error'), findsOneWidget);
    });
  });
}
