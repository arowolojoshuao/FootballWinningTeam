import 'dart:convert';

class Competition {
  Competition({
    this.id,
    this.area,
    this.name,
    this.code,
    this.currentSeason,
    this.seasons,
    this.lastUpdated,
  });

  final int? id;
  final Area? area;
  final String? name;
  final String? code;
  final Season? currentSeason;
  final List<Season>? seasons;
  final DateTime? lastUpdated;

  factory Competition.fromRawJson(String str) =>
      Competition.fromJson(json.decode(str));

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
        id: json["id"] == null ? null : json["id"],
        area: json["area"] == null ? null : Area.fromJson(json["area"]),
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        currentSeason: json["currentSeason"] == null
            ? null
            : Season.fromJson(json["currentSeason"]),
        seasons: json["seasons"] == null
            ? null
            : List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
      );
}

class Season {
  Season({
    this.id,
    this.startDate,
    this.endDate,
    this.currentMatchday,
    this.winner,
  });

  final int? id;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? currentMatchday;
  final Team? winner;

  factory Season.fromRawJson(String str) => Season.fromJson(json.decode(str));

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        id: json["id"] == null ? null : json["id"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        currentMatchday:
            json["currentMatchday"] == null ? null : json["currentMatchday"],
        winner: json["winner"] == null ? null : Team.fromJson(json["winner"]),
      );
}

class Team {
  Team({
    this.id,
    this.area,
    this.name,
    this.shortName,
    this.tla,
    this.crestUrl,
    this.address,
    this.phone,
    this.website,
    this.email,
    this.founded,
    this.clubColors,
    this.venue,
    this.lastUpdated,
    this.squad,
  });

  final int? id;
  final Area? area;
  final String? name;
  final String? shortName;
  final String? tla;
  final String? crestUrl;
  final String? address;
  final String? phone;
  final String? website;
  final String? email;
  final int? founded;
  final String? clubColors;
  final String? venue;
  final DateTime? lastUpdated;
  final List<SquadMember>? squad;

  factory Team.fromRawJson(String str) => Team.fromJson(json.decode(str));

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"] == null ? null : json["id"],
        area: json["area"] == null ? null : Area.fromJson(json["area"]),
        name: json["name"] == null ? null : json["name"],
        shortName: json["shortName"] == null ? null : json["shortName"],
        tla: json["tla"] == null ? null : json["tla"],
        crestUrl: json["crestUrl"] == null ? null : json["crestUrl"],
        address: json["address"] == null ? null : json["address"],
        phone: json["phone"] == null ? null : json["phone"],
        website: json["website"] == null ? null : json["website"],
        email: json["email"] == null ? null : json["email"],
        founded: json["founded"] == null ? null : json["founded"],
        clubColors: json["clubColors"] == null ? null : json["clubColors"],
        venue: json["venue"] == null ? null : json["venue"],
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
        squad: json["squad"] == null
            ? null
            : List<SquadMember>.from(
                json["squad"].map((x) => SquadMember.fromJson(x))),
      );
}

class SquadMember {
  SquadMember({
    this.id,
    this.name,
    this.position,
    this.nationality,
    this.role,
  });

  final int? id;
  final String? name;
  final Position? position;
  final String? nationality;
  final Role? role;

  factory SquadMember.fromRawJson(String str) =>
      SquadMember.fromJson(json.decode(str));

  factory SquadMember.fromJson(Map<String, dynamic> json) => SquadMember(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        position: json["position"] == null
            ? null
            : positionValues.map[json["position"]],
        nationality: json["nationality"] == null ? null : json["nationality"],
        role: json["role"] == null ? null : roleValues.map[json["role"]],
      );
}

enum Position { DEFENDER, MIDFIELDER, GOALKEEPER, ATTACKER }

final positionValues = EnumValues({
  "Attacker": Position.ATTACKER,
  "Defender": Position.DEFENDER,
  "Goalkeeper": Position.GOALKEEPER,
  "Midfielder": Position.MIDFIELDER
});

enum Role { PLAYER }

final roleValues = EnumValues({"PLAYER": Role.PLAYER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (_reverseMap == null) {
      _reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return _reverseMap!;
  }
}

class Area {
  Area({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory Area.fromRawJson(String str) => Area.fromJson(json.decode(str));

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );
}

class FootballMatch {
  FootballMatch({
    this.id,
    this.utcDate,
    this.status,
    this.score,
    this.homeTeam,
    this.awayTeam,
  });

  final int? id;
  final DateTime? utcDate;
  final String? status;
  final Score? score;
  final Team? homeTeam;
  final Team? awayTeam;

  factory FootballMatch.fromRawJson(String str) =>
      FootballMatch.fromJson(json.decode(str));

  factory FootballMatch.fromJson(Map<String, dynamic> json) => FootballMatch(
        id: json["id"] == null ? null : json["id"],
        utcDate:
            json["utcDate"] == null ? null : DateTime.parse(json["utcDate"]),
        status: json["status"] == null ? null : json["status"],
        score: json["score"] == null ? null : Score.fromJson(json["score"]),
        homeTeam:
            json["homeTeam"] == null ? null : Team.fromJson(json["homeTeam"]),
        awayTeam:
            json["awayTeam"] == null ? null : Team.fromJson(json["awayTeam"]),
      );
}

class Score {
  Score({
    this.winner,
  });

  final MatchWinner? winner;

  factory Score.fromRawJson(String str) => Score.fromJson(json.decode(str));

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        winner: json["winner"] == null ? null : _winnerFromJson(json["winner"]),
      );
}

MatchWinner _winnerFromJson(String json) {
  switch (json) {
    case 'HOME_TEAM':
      return MatchWinner.home;
    case 'AWAY_TEAM':
      return MatchWinner.away;
    case 'DRAW':
      return MatchWinner.draw;
    default:
      return MatchWinner.nul;
  }
}

enum MatchWinner { home, away, draw, nul }
