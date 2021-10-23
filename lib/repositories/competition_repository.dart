import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:team_wins/constants.dart';
import 'package:team_wins/data_models.dart';
import 'package:team_wins/http_utils.dart';

class CompetitionRepository {
  final int competitionId;
  final http.Client _client;
  final HttpUtil httpUtil;

  CompetitionRepository(this.competitionId, this._client,
      {this.httpUtil: const HttpUtil()});



  Future<Season> getLastSeason() async {
    final response = await httpUtil.wrapRemoteCall(
        http.Request(
          'GET',
          Uri.parse(API_URL + '/competitions/$competitionId'),
        ),
        _client);
    // We can safely assume that it was a successful request at this point

    final competition = Competition.fromRawJson(response.body);
    var lastSeason = competition.currentSeason;

    // Appropriately select the correct season to use.
    // An example is 30 days before a new season,
    // the `currentSeason` it set to the new season
    // so there'll be no match data at this time.
    // This block of code tries to set the last season
    // as the last started season in a case like this.
    // There could also be the case where `currentSeason` is null
    // (more than 60 days after the last completed season
    // and more than 30 days before the new season)
    if (lastSeason == null || lastSeason.startDate!.isAfter(DateTime.now())) {
      for (final season in competition.seasons!) {
        if (season.startDate!.isBefore(DateTime.now())) {
          lastSeason = season;
          break;
        }
      }
    }

    return lastSeason!;
  }

  DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  Future<List<FootballMatch>> getDataFromLastNDays(int n) async {
    final lastSeason = await getLastSeason();
    final DateTime dateTo;

    // If the season has ended, we want to set
    // the reference (last) date to the last match
    // in the season (the end date of the season)
    if (lastSeason.endDate!.isBefore(DateTime.now())) {
      dateTo = lastSeason.endDate!;
    } else {
      dateTo = DateTime.now();
    }

    // The date to start from is `n` days before the last date
    final dateFrom = dateTo.subtract(Duration(days: n));

    final request = http.Request(
      'GET',
      Uri.parse(
        API_URL +
            '/competitions/$competitionId/matches?'
                'status=FINISHED'
                '&dateFrom=${_apiDateFormat.format(dateFrom)}'
                '&dateTo=${_apiDateFormat.format(dateTo)}',
      ),
    );
    final response = await httpUtil.wrapRemoteCall(request, _client);
    // We can safely assume the request was successful at this point

    final data = jsonDecode(response.body);
    final List matches = data['matches'];
    return List<FootballMatch>.from(
        matches.map((e) => FootballMatch.fromJson(e)));
  }
}
