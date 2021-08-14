import 'dart:convert';

import 'package:http/http.dart';
import 'package:pokemon_dictionary/services/pokemon.dart';

class AllPokemon {

  String offset, limit;
  // Constructor
  AllPokemon({
    this.offset,
    this.limit
  });

  String results;
  List<dynamic> allPokemonList;


  // Empty constructor


  Future<void> getInstance() async {
    final String url = "https://pokeapi.co/api/v2/pokemon/?offset=$offset&limit=$limit";
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