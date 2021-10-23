import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:team_wins/constants.dart';
import 'package:team_wins/data_models.dart';
import 'package:team_wins/http_utils.dart';
import 'package:team_wins/repositories/competition_repository.dart';
import 'package:team_wins/repositories/teams_repository.dart';

import 'response_data.dart';

class MockCompetitionRepository implements CompetitionRepository {
  @override
  int get competitionId => throw UnimplementedError();

  @override
  Future<List<FootballMatch>> getDataFromLastNDays(int n) {
    final teams = [for (int i = 0; i < 11; i++) Team(id: i + 1)];
    final matches = [
      for (final team in teams.sublist(1))
        FootballMatch(
            homeTeam: teams[0],
            awayTeam: team,
            score: Score(winner: MatchWinner.home))
    ];
    return Future.value(matches);
  }

  @override
  Future<Season> getLastSeason() {
    throw UnimplementedError();
  }

  @override
  HttpUtil get httpUtil => throw UnimplementedError();
}

void main() {
  group("CompetitionRepository returns valid data", () {
    late CompetitionRepository competitionRepo;
    late http.Client client;
    late TeamsRepository teamRepo;

    Future<http.Response> mockRequestResponses(http.Request request) async {
      if (!request.headers.containsKey('x-auth-token'))
        return http.Response(
            jsonEncode({
              'message': "You don't have access to the requested resource."
            }),
            403);
      if (request.url == Uri.parse(API_URL + '/teams/1')) {
        return http.Response(jsonEncode(TEAM_1), 200);
      }
      return http.Response(
          jsonEncode({'message': "The requested resource was not found"}), 404);
    }

    setUp(() {
      client = MockClient(mockRequestResponses);
      competitionRepo = CompetitionRepository(2003, client);
      teamRepo = TeamsRepository(competitionRepo, client);
    });

    test("should get proper win data", () async {
      final idToWinMap = await teamRepo.getTeamIdsWithWins(30);
      expect(idToWinMap[1], 10);
    });

    test("should get team with max win", () async {
      final team = await teamRepo.getTeamWithMaxWins();
      expect(team.id, equals(1));
    });
  });
}
