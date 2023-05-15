import 'package:c8_ios/myOffers.dart';
import 'package:flutter/material.dart';
import 'specificItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'color.dart' as color;

class MakeBid extends StatefulWidget {
  const MakeBid({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MakeBidState();
}

class _MakeBidState extends State<MakeBid> {
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

/*class MakeBid extends StatelessWidget {*/
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );
    final style2 = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Make bid'),
        backgroundColor: color.primary,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Select your bidding',
                  style: style,
                ),
              ),
            ],
          ),
          // TODO få in rätt user
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04),
                child: Text(
                  // TODO få in rätt user
                  'Lars',
                  style: style2,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  // containern längst bak
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.4,
                  color: Color.fromARGB(255, 232, 238, 237),
                  child: FutureBuilder<List<dynamic>>(
                    // scrollbar lista inuti
                    future: _futureListings,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final listings = snapshot.data!;
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0; i < listings.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ListingDetailPage(
                                        listingId: listings[i]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Item(string: listings[i]['name']),
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
              )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.04,
                    MediaQuery.of(context).size.width * 0.04,
                    MediaQuery.of(context).size.width * 0.04,
                    0),
                child: Text(
                  'Your',
                  style: style2,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  // containern längst bak
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.4,
                  color: Color.fromARGB(255, 232, 238, 237),
                  child: FutureBuilder<List<dynamic>>(
                    // scrollbar lista inuti
                    future: _futureListings,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final listings = snapshot.data!;
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0; i < listings.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ListingDetailPage(
                                        listingId: listings[i]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Item(string: listings[i]['name']),
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
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SmallCard(
                    string: 'Cancel',
                    color: Color.fromARGB(255, 211, 211, 211)),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => OffersPage(),
                      ),
                    );
                  },
                  child: SmallCard(
                      string: 'Ok', color: Color.fromARGB(255, 165, 206, 146)))
            ],
          )
        ],
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  SmallCard({required this.string, required this.color});

  final String string;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08),
      child: Row(children: [
        Card(
          color: color,
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
            child: Text(
              string,
              style: style,
            ),
          ),
        ),
      ]),
    );
  }
}

class Item extends StatelessWidget {
  Item({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.28,
          child: Image.asset(
            'images/shoes.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            string,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
