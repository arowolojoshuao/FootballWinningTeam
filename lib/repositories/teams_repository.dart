import 'package:http/http.dart' as http;
import 'package:team_wins/data_models.dart';
import 'package:team_wins/http_utils.dart';

import '../constants.dart';
import 'competition_repository.dart';

class TeamsRepository {
  final CompetitionRepository _competitionRepository;
  final http.Client _client;
  final HttpUtil httpUtil;

  TeamsRepository(this._competitionRepository, this._client,
      {this.httpUtil: const HttpUtil()});

  Future<Team?> getTeamById(int id) async {
    final response = await httpUtil.wrapRemoteCall(
        http.Request('GET', Uri.parse(API_URL + '/teams/$id')), _client);

    return Team.fromRawJson(response.body);
  }

  Future<Map<int, int>> getTeamIdsWithWins([int lastNDays = 30]) async {
    final matches =
        await _competitionRepository.getDataFromLastNDays(lastNDays);

    // For holding the win count of teams
    final idToWinMapping = Map<int, int>();

    // Calculate the number of wins for each team
    for (final match in matches) {
      final int? winnerId;
      switch (match.score!.winner) {
        case MatchWinner.home:
          winnerId = match.homeTeam?.id;
          break;
        case MatchWinner.away:
          winnerId = match.awayTeam?.id;
          break;
        default:
          winnerId = null;
          break;
      }

      // If there was a winner, update that team's win count
      if (winnerId != null) {
        if (!idToWinMapping.containsKey(winnerId)) idToWinMapping[winnerId] = 0;
        idToWinMapping[winnerId] = idToWinMapping[winnerId]! + 1;
      }
    }
    return idToWinMapping;
  }

  //Return Team with maximum value
  Future<Team> getTeamWithMaxWins([int lastNDays = 30]) async {
    final idToWinMapping = await getTeamIdsWithWins(lastNDays);
    int maxWinId = 0; // 0 is a stub here
    int maxWinValue = 0;
    idToWinMapping.forEach((key, value) {
      if (value > maxWinValue) {
        maxWinId = key;
        maxWinValue = value;
      }
    });

    return (await getTeamById(maxWinId))!;
  }
}
