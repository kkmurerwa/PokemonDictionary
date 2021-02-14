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

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    list = data["list"];


    Future<void> _searchChanged(String search) async {
      AllPokemon allPokemon =  AllPokemon(offset: "0", limit: "1118");

      await allPokemon.getInstance();

      searchList.clear();

      if (search == null || search.trim().length ==0) {
        setState(() {
          _isSearching = false;
          listLength = list.length;
        });
      } else {
        print(search);

        allPokemon.allPokemonList.asMap().forEach((i, value) {
          if (value["name"].contains(search.toLowerCase())) {
            // print(value["name"]);
            searchList.add(value);
          }
        });

        setState(() {
          _isSearching = true;
          listLength = searchList.length;
        });
      }
    }

    Future _loadMoreData() async {
      AllPokemon allPokemon = AllPokemon(offset: _offset.toString(), limit: "10");

      await allPokemon.getInstance();

      list.addAll(allPokemon.allPokemonList);

      // update data and loading status
      setState(() {
        _isLoading = false;
        listLength = list.length;
      });
    }

    listLength = _isSearching ? searchList.length : list.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorSecondary,
        title: Text(
            "All Pokemon",
        ),
        centerTitle: true,
        elevation: 0,
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
                SliverFixedExtentList(
                  itemExtent: 58,
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextField(
                        cursorColor: colorSecondary,
                        onChanged: (changed){
                          _searchChanged(changed);
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
                    );
                  },
                    childCount: 1,
                  ),
                ),
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

  void viewPokemonDetails(Map item) {
    print(item);
    String name = item["name"].substring(0, 1).toUpperCase() + item["name"].substring(1);
    Navigator.pushNamed(context, "/attributes", arguments: {
      "name" : name,
      "url" : item["url"]
    });
  }

  Widget _widgetGridView(List<dynamic> passedList){
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              // String timeURL = locations[index].locationUrl;
              // print(timeURL);
              viewPokemonDetails(passedList[index]);
            },
            child: Card(
              child: Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Image.network(
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${passedList[index]["url"].split("/")[6]}.png",
                      // "https://pokeres.bastionbot.org/images/pokemon/${passedList[index]["url"].split("/")[6]}.png",
                      height: 120.0,
                      fit: BoxFit.fitWidth,
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
                    SizedBox(height: 10.0,),
                    Text(
                      passedList[index]["name"].substring(0, 1).toUpperCase() + passedList[index]["name"].substring(1),
                      style: TextStyle(
                          fontSize: 16
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

