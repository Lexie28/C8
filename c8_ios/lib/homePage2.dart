import 'package:c8_ios/categories.dart';
import 'package:c8_ios/otherProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'secondmain.dart';
import '../toolbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage2> {
  //late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    //  futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle 8'),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Color.fromARGB(255, 162, 186, 191),
      ),
      //bottomNavigationBar: toolbar(),
      body: Center(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Här är alla widgetar
          Header(string: 'Categories'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Category(string: 'Clothes'),
              Category(string: 'Shoes'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Category(string: 'Food'),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Categories(),
                      ),
                    );
                  },
                  child: Category(string: 'All categories')),
            ],
          ),
          Header(string: 'Popular items'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => OtherProduct(),
                    ),
                  );
                },
                child: Item(string: 'Shoes')),
            Item(string: 'Flaming tequila'),
            Item(string: 'Product name'),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Item(string: 'Product name'),
            Item(string: 'Product name'),
            Item(string: 'Product name'),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Item(string: 'Product name'),
            Item(string: 'Product name'),
            Item(string: 'Product name')
          ]),
        ]),
      )),
    );
  }
}

class Item extends StatelessWidget {
  // TODO se till att strängen int är längre än en rad för då blir rutan ful

  Item({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      color: Color.fromARGB(255, 195, 195, 195),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            child: ClipRRect(
              //borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                'images/shoes.png',
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
            ),
          ),
          Text(string),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.tertiary),
      ),
      color: theme.colorScheme.tertiary,
      elevation: 10,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  Category({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.inversePrimary,
      elevation: 5,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.35,
        child: Center(
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}
/*
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // allt är lugnt
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}*/
