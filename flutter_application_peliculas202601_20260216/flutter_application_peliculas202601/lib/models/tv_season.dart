import 'dart:convert';

class TvSeason {
  TvSeason({
    this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  String? airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String? posterPath;
  int seasonNumber;
  double voteAverage;

  String get fullPosterPath {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  factory TvSeason.fromJson(String str) => TvSeason.fromMap(json.decode(str));

  factory TvSeason.fromMap(Map<String, dynamic> json) => TvSeason(
        airDate: json["air_date"],
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"] ?? '',
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
      );
}

class TvEpisode {
  TvEpisode({
    this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    this.stillPath,
    required this.seasonNumber,
    required this.voteAverage,
    required this.voteCount,
    this.runtime,
  });

  String? airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String? stillPath;
  int seasonNumber;
  double voteAverage;
  int voteCount;
  int? runtime;

  String get fullStillPath {
    if (stillPath != null) {
      return 'https://image.tmdb.org/t/p/w500$stillPath';
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  factory TvEpisode.fromJson(String str) => TvEpisode.fromMap(json.decode(str));

  factory TvEpisode.fromMap(Map<String, dynamic> json) => TvEpisode(
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"] ?? '',
        stillPath: json["still_path"],
        seasonNumber: json["season_number"],
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
        voteCount: json["vote_count"] ?? 0,
        runtime: json["runtime"],
      );
}

class TvSeasonDetail {
  TvSeasonDetail({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.episodes,
  });

  int id;
  String name;
  String overview;
  String? posterPath;
  int seasonNumber;
  List<TvEpisode> episodes;

  factory TvSeasonDetail.fromJson(String str) =>
      TvSeasonDetail.fromMap(json.decode(str));

  factory TvSeasonDetail.fromMap(Map<String, dynamic> json) => TvSeasonDetail(
        id: json["id"],
        name: json["name"],
        overview: json["overview"] ?? '',
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
        episodes: List<TvEpisode>.from(
            json["episodes"].map((x) => TvEpisode.fromMap(x))),
      );
}
