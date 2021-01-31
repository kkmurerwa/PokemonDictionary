import 'dart:convert';

import 'package:http/http.dart';

class Pokemon {
  String url;



  // Constructor
  Pokemon({
    this.url,
  });


  Future<Map> getPokemonDetails() async {
    Map data;
    try {
      // Make API Request
      Response response = await get("$url");
      data = jsonDecode(response.body);
      // print(data);

      // Get properties from response map
      // String name = data["name"];
      // String height = data["height"];
      // String weight = data["weight"];
      // String abilities = data["abilities"];

      return data;

      // String abilities = data["abilities"].substring(0, 3);
    } catch (exception) {
      print(exception);
      data["error"] = "error";
    }
  }

}