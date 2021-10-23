import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:team_wins/data_models.dart';
import 'package:team_wins/repositories/competition_repository.dart';
import 'package:team_wins/repositories/teams_repository.dart';

final winningTeamProvider =
    AutoDisposeFutureProviderFamily<Team, int>((ref, competitionId) {
  final client = http.Client();
  final competitionRepository = CompetitionRepository(competitionId, client);
  final teamRepository = TeamsRepository(competitionRepository, client);
  return teamRepository.getTeamWithMaxWins();
});
