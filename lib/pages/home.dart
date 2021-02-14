import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_dictionary/services/all_pokemon.dart';
import 'package:pokemon_dictionary/services/pokemon.dart';
import 'package:pokemon_dictionary/values/colors/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  List<dynamic> list;

  List<dynamic> searchList = new List();
  int _offset = 0;

  var _isLoading = false;
  bool _isSearching = false;
  int listLength;

  void viewPokemonDetails(Map item) {
    print(item);
    String name = item["name"].substring(0, 1).toUpperCase() + item["name"].substring(1);
    Navigator.pushNamed(context, "/attributes", arguments: {
      "name" : name,
      "url" : item["url"]
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    list = data["list"];


    Future<void> _searchChanged(String search) async {
      // Initialize object
      AllPokemon allPokemon =  AllPokemon(offset: "0", limit: "1118");

      // Fetch from API
      await allPokemon.getInstance();

      // Clear previous list
      searchList.clear();

      // Handle null searches
      if (search == null || search.trim().length ==0) {
        setState(() {
          _isSearching = false;
          listLength = list.length;
        });
      } else {// Handle string searches
        print(search);

        allPokemon.allPokemonList.asMap().forEach((i, value) {
          if (value["name"].contains(search.toLowerCase())) {
            // print(value["name"]);
            searchList.add(value);
          }
        });

        // Display data
        setState(() {
          _isSearching = true;
          listLength = searchList.length;
        });
      }
    }

    Future _loadMoreData() async {
      // Initialize fetch object
      AllPokemon allPokemon = AllPokemon(offset: _offset.toString(), limit: "10");

      // Fetch API
      await allPokemon.getInstance();

      // Add retrieved fields to current list
      list.addAll(allPokemon.allPokemonList);

      // update data and loading status
      setState(() {
        _isLoading = false;
        listLength = list.length;
      });
    }

    // Handle list size changes
    listLength = _isSearching ? searchList.length : list.length;

    return Scaffold(
      appBar: CustomAppBar(
        height: 80.0,
        searchChanged: _searchChanged,
      ),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoading && !_isSearching && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                // start loading data
                setState(() {
                  _isLoading = true;
                  _offset = _offset + 10;
                });
                _loadMoreData();
              }
              return true;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                _isSearching ?
                  _widgetGridView(searchList) :
                  _widgetGridView(list),
                SliverFixedExtentList(
                  itemExtent: !_isSearching ? 60 : 0,
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container(
                      child: SpinKitRipple(
                        color: colorSecondary,
                      )
                    );
                  },
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _widgetGridView(List<dynamic> passedList){
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.98,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              // String timeURL = locations[index].locationUrl;
              // print(timeURL);
              viewPokemonDetails(passedList[index]);
            },
            child: Container(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        ),
                        child: Image.network(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${passedList[index]["url"].split("/")[6]}.png",
                          // "https://pokeres.bastionbot.org/images/pokemon/${passedList[index]["url"].split("/")[6]}.png",
                          height: 120.0,
                          fit: BoxFit.contain,
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              child: SpinKitFadingCircle(
                                color: colorSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Center(
                        child: Text(
                          passedList[index]["name"].substring(0, 1).toUpperCase() + passedList[index]["name"].substring(1),
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          );
        },
        childCount: listLength,
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final double height;
  final Function searchChanged;

  CustomAppBar({@required this.height, this.searchChanged});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: TextField(
          cursorColor: colorSecondary,
          onChanged: (changed){
            searchChanged(changed);
          },
          style: TextStyle(
            fontSize: 19,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10, top: 15),
              hintText: "Search",
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF000000).withOpacity(0.5),
              )
          ),
        ),
      ),
    );
  }
}

