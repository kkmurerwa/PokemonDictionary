import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    list = data["list"];

    // print(data);

    // Get color argument from calling activity
    Color bgColor = Colors.green[900];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
            "All Pokemon"
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  // String timeURL = locations[index].locationUrl;
                  // print(timeURL);
                  viewPokemonDetails(list[index]);
                },
                title: Text(
                    list[index]["name"].substring(0, 1).toUpperCase() + list[index]["name"].substring(1)
                ),
                // leading: CircleAvatar(
                //   backgroundImage: AssetImage('assets/${[index].flagUrl}'),
                // ),
              ),
            ),
          );
        },
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

