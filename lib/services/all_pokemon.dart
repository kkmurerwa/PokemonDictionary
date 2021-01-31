import 'dart:convert';

import 'package:http/http.dart';
import 'package:pokemon_dictionary/services/pokemon.dart';

class AllPokemon {
  final String url = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=50";

  String results;
  List<dynamic> allPokemonList;


  // Empty constructor
  AllPokemon();

  Future<void> getInstance() async {
    try {
      // Make API Request
      Response response = await get("$url");
      Map data = jsonDecode(response.body);
      allPokemonList = data["results"];

      // print(myList[0]["url"]);

      // Get properties from response map
      // results = jsonDecode(data["results"]);
      //
      // print(results);



    } catch (exception) {
      print(exception);
      allPokemonList =[];
    }
  }
}