import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_dictionary/services/all_pokemon.dart';
import 'package:pokemon_dictionary/values/colors/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  List<dynamic> list;
  int _offset = 0;

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    list = data["list"];
    // print(list[1]["url"].split("/")[6]);


    Future _loadData() async {
      AllPokemon allPokemon = AllPokemon(offset: _offset.toString());

      await allPokemon.getInstance();

      list.addAll(allPokemon.allPokemonList);

      // update data and loading status
      setState(() {
        _isLoading = false;
      });
    }

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
          color: Colors.grey[100],
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                // start loading data
                setState(() {
                  _isLoading = true;
                  _offset = _offset + 10;
                });
                _loadData();
              }
              return true;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                  itemExtent: 60,
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            cursorColor: Colors.purple[900],
                            decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF000000).withOpacity(0.5),
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                    childCount: 1,
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          // String timeURL = locations[index].locationUrl;
                          // print(timeURL);
                          viewPokemonDetails(list[index]);
                        },
                        child: Card(
                          child: Container(
                            constraints: BoxConstraints.expand(),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Image.network(
                                  // "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${list[index]["url"].split("/")[6]}.png",
                                  "https://pokeres.bastionbot.org/images/pokemon/${list[index]["url"].split("/")[6]}.png",
                                  height: 150.0,
                                  fit: BoxFit.fitWidth,
                                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 150,
                                      child: SpinKitFadingCircle(
                                        color: colorSecondary,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10.0,),
                                Text(
                                  list[index]["name"].substring(0, 1).toUpperCase() + list[index]["name"].substring(1),
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
                    childCount: list.length,
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: _isLoading ? 60 : 0,
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
}

