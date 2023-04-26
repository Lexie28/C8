import 'package:c8_ios/categories.dart';
//import 'package:c8_ios/otherProduct.dart';
//import 'package:c8_ios/popularItems.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'secondmain.dart';
//import '../toolbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'listingscategory.dart';
import 'specificitem.dart';
import 'api.dart';
import 'popularItems.dart';
import 'otherProduct.dart';

class HomePage3 extends StatefulWidget {
  const HomePage3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage3> {
  late Future<List<dynamic>> _futureListings;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _futureListings = fetchPopular();
  }

  Future<List<dynamic>> fetchPopular() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing?sort=popular&amount=5'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch listings');
    }
  }

  void _navigateToListingsPage(String category) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ListingsPage(category: category),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: FractionalOffset.center,
          child: const Text('Circle 8'),
        ),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 232, 237, 238),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color.fromARGB(255, 232, 237, 238),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Color.fromARGB(255, 232, 237, 238),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            _navigateToListingsPage('Clothing');
                          },
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                //color: Colors.yellow,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        'images/shirticon.png'),
                                    Text('Clothing')
                                  ],
                                ),
                              ),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            _navigateToListingsPage('Shoes');
                          },
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                //color: Colors.yellow,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        'images/shoeicon.png'),
                                    Text('Shoes')
                                  ],
                                ),
                              ),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            _navigateToListingsPage('Books');
                          },
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                //color: Colors.yellow,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        'images/bookicon.png'),
                                    Text('Books')
                                  ],
                                ),
                              ),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Categories(),
                            ));
                          },
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                //color: Colors.yellow,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        'images/categoriesicon.png'),
                                    Text('More ')
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.topCenter,
                child: Text(
                  'Popular Items',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 241, 245, 246),
                child: FutureBuilder<List<dynamic>>(
                  future: _futureListings,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final listings = snapshot.data!;
                      final showMoreItems = listings.length > 4;
                      return Wrap(
                        spacing:
                            16.0, // set the horizontal spacing between items
                        runSpacing:
                            16.0, // set the vertical spacing between items
                        children: [
                          for (int i = 0; i < 5; i++)
                            Container(
                              width: (MediaQuery.of(context).size.width -
                                      32.0) /
                                  2, // calculate the width of each item based on the screen width and the spacing between items
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListingDetailPage(
                                        listingId: listings[i]['id'].toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Item(
                                  string: listings[i]['name'],
                                  image: 'images/shoes.png',
                                ),
                              ),
                            ),
                          if (showMoreItems)
                            Container(
                              width: (MediaQuery.of(context).size.width * 0.45),
                              height: (MediaQuery.of(context).size.width *
                                  0.45), // calculate the width of the "See more items" box based on the screen width and the spacing between items
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
                                    color: Color.fromARGB(255, 210, 208, 208),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'See more items',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 83, 83, 83),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  // TODO se till att strängen int är längre än en rad för då blir rutan ful

  Item({
    required this.string,
    required this.image,
  });

  final String string;
  final String image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Material(
      elevation: 7,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                /*
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset(
                'images/shoes.png',
                fit: BoxFit.cover,
              */
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
