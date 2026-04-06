//import 'dart:convert';

import 'package:fl_componentes/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RickMortyProvider extends ChangeNotifier {

  final String _baseUrl = 'rickandmortyapi.com';
  
  List<Character> onDisplayCharacter = []; 

  RickMortyProvider(){
    print('RickyMortyProvider Inicializado');

    getOnDisplayCharacters();
  }

  getOnDisplayCharacters() async{
    print('getOnDisplayCharacters');


    //https://rickandmortyapi.com/api/character
    var url = Uri.https(_baseUrl, 'api/character', {
      'page': '1'
    });

    final response = await http.get(url);

    
    
    //final Map<String,dynamic> decodeData = json.decode(response.body);

    final rickyMortyResponse = RickyMortyResponse.fromJson(response.body);


    //if (response.statusCode != 200) return('error');

    //print(decodeData['results']);
    //print(rickyMortyResponse.results[0].name);

    onDisplayCharacter = rickyMortyResponse.results;

    notifyListeners();

  }

}