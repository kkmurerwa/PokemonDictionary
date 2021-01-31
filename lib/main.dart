import 'package:flutter/material.dart';
import 'package:pokemon_dictionary/pages/loading_screen.dart';
import 'package:pokemon_dictionary/pages/home.dart';
import 'package:pokemon_dictionary/pages/pokemon_attributes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/" : (context) => Loading() ,
      "/home" : (context) => Home(),
      "/attributes" : (context) => PokemonAttributes()
    },
  ));
}
