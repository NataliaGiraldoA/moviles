import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:flutter_application_peliculas202601/models/models.dart';
import 'package:flutter_application_peliculas202601/models/tv_season.dart';


class MoviesProvider extends ChangeNotifier {


 //Variables de llamado de la API/KEY


 //Profe
 //b4d25e9dd65721da4a58c5933d61de37


 //Otra
 //1865f43a0549ca50d341dd9ab8b29f49


 final String _apiKey   = '4ec134e6f54abd7798c8923c4f3d24b2';
 final String _baseUrl  = 'api.themoviedb.org';
 final String _language = 'es-ES';


 List<Movie> onDisplayMovies = [];
 List<Movie> popularMovies   = [];
 List<Movie> upcomingMovies   = [];


 Map<int, List<Cast>> moviesCast = {};
  
 int _popularPage = 0;


 MoviesProvider() {
   print('MoviesProvider inicializado');


   getOnDisplayMovies();
   getPopularMovies();
   getUpcomingMovies();


 }


 Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
   final url = Uri.https( _baseUrl, endpoint, {
     'api_key': _apiKey,
     'language': _language,
     'page': '$page'
   });


   // Await the http get response, then decode the json-formatted response.
   final response = await http.get(url);
   return response.body;
 }




 Future<void> getOnDisplayMovies() async {
  
   //https://api.themoviedb.org/3/movie/now_playing?api_key=b4d25e9dd65721da4a58c5933d61de37
   final jsonData = await _getJsonData('3/movie/now_playing');
   final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
  
   onDisplayMovies = nowPlayingResponse.results;
  
   notifyListeners();
 }


 Future<void> getUpcomingMovies() async {

   final jsonData = await _getJsonData('3/movie/upcoming');
   final upcomingResponse = NowPlayingResponse.fromJson(jsonData);

   upcomingMovies = upcomingResponse.results;

   notifyListeners();
 }


 Future<void> getPopularMovies() async {


   _popularPage++;


   final jsonData = await _getJsonData('3/movie/popular', _popularPage );
   final popularResponse = PopularResponse.fromJson( jsonData );
  
   popularMovies = [ ...popularMovies, ...popularResponse.results ];
   notifyListeners();
 }


 Future<List<Cast>> getMovieCast( int movieId ) async {


   if( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;


   final jsonData = await _getJsonData('3/movie/$movieId/credits');
   final creditsResponse = CreditsResponse.fromJson( jsonData );


   moviesCast[movieId] = creditsResponse.cast;


   return creditsResponse.cast;
 }


 Future<List<TvSeason>> getRickAndMortySeasons() async {
   final jsonData = await _getJsonData('3/tv/60625');
   final Map<String, dynamic> decoded = json.decode(jsonData);
   final seasons = List<TvSeason>.from(
     decoded['seasons'].map((x) => TvSeason.fromMap(x)),
   );
   return seasons;
 }


 Future<TvSeasonDetail> getRickAndMortySeason(int seasonNumber) async {
   final jsonData = await _getJsonData('3/tv/60625/season/$seasonNumber');
   return TvSeasonDetail.fromJson(jsonData);
 }


}
