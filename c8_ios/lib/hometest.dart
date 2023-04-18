import 'package:c8_ios/categories.dart';
import 'package:c8_ios/otherProduct.dart';
import 'package:c8_ios/popularItems.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'secondmain.dart';
//import '../toolbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'clothingcategory.dart';

class HomePage3 extends StatefulWidget {
  const HomePage3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage3> {
  late Future<List<dynamic>> _futureListings;

  @override
  void initState() {
    super.initState();
    _futureListings = fetchPopular();
  }

  Future<List<dynamic>> fetchPopular() async {
    final response = await http
        .get(Uri.parse('http://130.243.236.34:3000/listing/top5popular'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle 8'),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Color.fromARGB(255, 162, 186, 191),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(string: 'Categories'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListingsPage(),
                      ),
                    );
                  },
                  child: Category(string: 'Clothes'),
                ),
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
                  child: Category(string: 'All categories'),
                ),
              ],
            ),
            Header(string: 'Popular items'),
            FutureBuilder<List<dynamic>>(
              future: _futureListings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listings = snapshot.data!;
                  final showMoreItems = listings.length > 5;
                  return Wrap(
                    spacing: 16.0, // set the horizontal spacing between items
                    runSpacing: 16.0, // set the vertical spacing between items
                    children: [
                      for (int i = 0; i < listings.length && i < 5; i++)
                        Container(
                          width: (MediaQuery.of(context).size.width - 48.0) /
                              3, // calculate the width of each item based on the screen width and the spacing between items
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OtherProduct(),
                                ),
                              );
                            },
                            child: Item(string: listings[i]['listing_name']),
                          ),
                        ),
                      Container(
                        width: (MediaQuery.of(context).size.width * 0.8) / 3,
                        height: (MediaQuery.of(context).size.width * 1.1) /
                            3, // calculate the width of the "See more items" box based on the screen width and the spacing between items
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PopularItems(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[200],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'See more items',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Failed to fetch listings');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
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
}
