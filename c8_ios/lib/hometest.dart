import 'package:c8_ios/categories.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'listingscategory.dart';
import 'specificitem.dart';
import 'api.dart';
import 'popularItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _futureListings;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _futureListings = fetchPopular();
  }

  Future<List<dynamic>> fetchPopular() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final response = await http.get(Uri.parse(
        '${_api.getApiHost()}/listing?sort=popular&amount=5&exclude_user=$userId'));
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
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Text(
                    'Categories',
                    style: GoogleFonts.kalam(
                      //kalam
                      textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Color.fromARGB(255, 226, 232, 234),
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
                            _navigateToListingsPage('Accessories');
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
                                    Text('Accesories')
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
                color: Color.fromARGB(255, 255, 255, 255),
                child: FutureBuilder<List<dynamic>>(
                  future: _futureListings,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final listings = snapshot.data!;
                      final showMoreItems = listings.length > 4;
                      return Wrap(
                        spacing: 16.0, // horizontal spacing between items
                        runSpacing: 16.0, // vertical spacing between items
                        children: [
                          for (int i = 0; i < listings.length && i < 5; i++)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      32.0) /
                                  2, // calculate the width of each item based on the screen width and the spacing between items
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListingDetailPage(
                                        listingId: listings[i]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Item(
                                  string: listings[i]['name'],
                                  image: listings[i]['image_path'],
                                ),
                              ),
                            ),
                          if (showMoreItems)
                            SizedBox(
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
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Color.fromARGB(255, 215, 215, 215),
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
  Item({
    required this.string,
    required this.image,
  });

  final String string;
  final String image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Material(
      elevation: 7,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                'https://circle8.s3.eu-north-1.amazonaws.com/$image',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            string,
            style: style,
          ),
        ],
      ),
    );
  }
}
