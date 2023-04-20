import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'otherProfile.dart';

class ListingDetailPage extends StatefulWidget {
  final String listingId;

  ListingDetailPage({required this.listingId});

  @override
  _ListingDetailPageState createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  Map<String, dynamic> listing = {};
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    fetchListingDetails();
  }

  Future<void> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
        listing = decoded;
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Listing'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: ProductListing(string: 'images/shoes.jpg'),
                  ),
                  Align(
                      alignment: FractionalOffset.topRight,
                      child: ListingProfile(name: listing['user']['user_name'], likes: listing['user']['user_num_likes'].toString() )),
                  //CardProduct(string: 'Hej'),
                ],
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ProductName(string: listing['listing_name']),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ProductInfo(
                    string:
                        listing['listing_description']),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    //35,
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.width * 0.065,
                    MediaQuery.of(context).size.width * 0,
                    MediaQuery.of(context).size.width * 0,
                  ),
                  child: Text(
                    'Number of bids',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: NumBids(string: listing['num_bids'].toString()),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: BidButton(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ProductName extends StatelessWidget {
  const ProductName({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0,
        MediaQuery.of(context).size.width * 0,
        MediaQuery.of(context).size.width * 0.02,
      ),
      child: Text(
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1),
        string,
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return FittedBox(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Card(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.width * 0,
            MediaQuery.of(context).size.width * 0,
            MediaQuery.of(context).size.width * 0,
          ),
          color: theme.colorScheme.onSecondary,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Text(
              string,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class NumBids extends StatelessWidget {
  const NumBids({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.32,
      child: Card(
        margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.11,
          MediaQuery.of(context).size.width * 0,
          MediaQuery.of(context).size.width * 0,
          MediaQuery.of(context).size.width * 0,
        ),
        color: theme.colorScheme.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          //padding: const EdgeInsets.fromLTRB(23, 15, 15, 15),
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.065,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
          ),
          child: Text(
            string, //TODO: Kan inte ges som argument. Förmodligen pga stateful widget.
            style: style,
          ),
        ),
      ),
    );
  }
}

class BidButton extends StatefulWidget {
  const BidButton({super.key});

  @override
  State<BidButton> createState() => _BidButtonState();
}

class _BidButtonState extends State<BidButton> {
  String buttonName = "Bid";

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.2,
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0,
      ),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.height * 0.17,
      child: ElevatedButton(
        onPressed: () {
          /*
          setState(() {
            buttonName = "Bidded";
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MakeBid(),
            ),
          );
          */
        },
        child: Text(buttonName),
      ),
    );
  }
}

class ProductListing extends StatelessWidget {
  const ProductListing({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.08,
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.08,
      ),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        border: Border.all(width: 2.2, color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 113, 113, 113),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.5, 1.5), // shadow direction: bottom right
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.0),
        child: Image.asset(
          string,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ListingProfile extends StatelessWidget {
  //TODO: Fetch data från databas
  const ListingProfile({
    required this.name,
    required this.likes,
  });

  final String name;
  final String likes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0,
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => OtherProfile(),
                  ),
                );
              },
              child: Image.asset(
                'images/man.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const OtherProfile(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.width * 0,
            ),
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              children: [
                Text(
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06),
                  name,
                ),
                Text(likes), //TODO
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.07,
                  child: Image.asset(
                    'images/like.png', //TODO
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

  
          /*
          ListView(
              children: [
                ListTile(
                  title: Text('Listing Name'),
                  subtitle: Text(listing['listing_name']),
                ),
                ListTile(
                  title: Text('Listing Description'),
                  subtitle: Text(listing['listing_description']),
                ),
                ListTile(
                  title: Text('Listing Category'),
                  subtitle: Text(listing['listing_category']),
                ),
                ListTile(
                  title: Text('User Name'),
                  subtitle: Text(listing['user']['user_name']),
                ),
                ListTile(
                  title: Text('User Location'),
                  subtitle: Text(listing['user']['user_location']),
                ),
              ],
            ), */


/*
class _ListingDetailPageState extends State<ListingDetailPage> {
  Map<String, dynamic> listing = {};
  Api _api = Api();
  List<Widget> listTileWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchListingDetails();
  }

  Future<void> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            listing = decoded[0];
          } else {
            throw Exception('Failed to fetch listing details');
          }
        } else {
          throw Exception('Failed to fetch listing details');
        }

        // Retrieve user information from the API response
        final user = listing['user'];
        final userName = user['user_name'];
        final userLocation = user['user_location'];

        // Add the user information to the ListTile widgets
        listTileWidgets = [
          ListTile(
            title: Text('User ID'),
            subtitle: Text(listing['user_id'].toString()),
          ),
          ListTile(
            title: Text('Listing Name'),
            subtitle: Text(listing['listing_name']),
          ),
          ListTile(
            title: Text('Listing Description'),
            subtitle: Text(listing['listing_description']),
          ),
          ListTile(
            title: Text('Listing Category'),
            subtitle: Text(listing['listing_category']),
          ),
          ListTile(
            title: Text('User Name'),
            subtitle: Text(userName),
          ),
          ListTile(
            title: Text('User Location'),
            subtitle: Text(userLocation),
          ),
        ];
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['listing_name'] ?? ''),
      ),
      body: listing.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: listTileWidgets,
            ),
    );
  }
}*/

  /*

  Future<void> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            listing = decoded[0];
          } else {
            throw Exception('Failed to fetch listing details');
          }
        } else {
          throw Exception('Failed to fetch listing details');
        }
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['listing_name'] ?? ''),
      ),
      body: listing.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text('User ID'),
                  subtitle: Text(listing['user_id'].toString()),
                ),
                ListTile(
                  title: Text('Listing Name'),
                  subtitle: Text(listing['listing_name']),
                ),
                ListTile(
                  title: Text('Listing Description'),
                  subtitle: Text(listing['listing_description']),
                ),
                ListTile(
                  title: Text('Listing Category'),
                  subtitle: Text(listing['listing_category']),
                ),
              ],
            ),
    );
  }
}*/
