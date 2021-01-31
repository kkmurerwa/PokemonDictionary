import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
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

      return data;
    } catch (exception) {
      print(exception);
      data["error"] = "error";
    }
  }

}