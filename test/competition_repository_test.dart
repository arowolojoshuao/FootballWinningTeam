import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:team_wins/constants.dart';
import 'package:team_wins/repositories/competition_repository.dart';

import 'response_data.dart';

void main() {
  group("CompetitionRepository returns valid data", () {
    late CompetitionRepository competitionRepo;
    late http.Client client;

    Future<http.Response> mockRequestResponses(http.Request request) async {
      if (!request.headers.containsKey('X-Auth-Token'))
        return http.Response(
            jsonEncode({
              'message': "You don't have access to the requested resource."
            }),
            403);
      if (request.url == Uri.parse(API_URL + '/competitions/2003')) {
        return http.Response(jsonEncode(COMPETITION_2003), 200);
      } else if (request.url.pathSegments.last == 'matches' &&
          // Strip off query parameters since we're not processing them
          request.url.resolve('matches') ==
              Uri.parse(API_URL + '/competitions/2003/matches')) {
        return http.Response(jsonEncode(COMPETITION_2003_MATCHES), 200);
      }
      return http.Response(
          jsonEncode({'message': "The requested resource was not found"}), 404);
    }

    setUp(() {
      client = MockClient(mockRequestResponses);
      competitionRepo = CompetitionRepository(2003, client);
    });

    test("should get valid last season", () async {
      final lastSeason = await competitionRepo.getLastSeason();
      expect(lastSeason.id, equals(728));
    });

    test("should get proper competition data", () async {
      final footballMatches = await competitionRepo.getDataFromLastNDays(30);
      expect(
        footballMatches.every(
            (element) => element.utcDate!.isAfter(DateTime(2021, 09, 22))),
        isTrue,
      );
    });
  });
}
