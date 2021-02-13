import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_dictionary/services/all_pokemon.dart';
import 'package:pokemon_dictionary/values/colors/colors.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String time = "Loading...";

  void getPokemon() async {
    AllPokemon allPokemon = AllPokemon();

    await allPokemon.getInstance();

    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "list": allPokemon.allPokemonList
    });
  }


  @override
  void initState() {
    super.initState();
    getPokemon();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 300.0),
          child: Column(
            children: <Widget> [
              SpinKitFadingCircle(
                color: colorSecondary,
                size: 80.0,
              ),
              SizedBox(height: 20.0),
              Text(
                "Loading pokemon",
                style: TextStyle(
                  fontSize: 30.0,
                  color: colorSecondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
