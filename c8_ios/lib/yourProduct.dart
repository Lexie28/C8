import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'secondmain.dart';
import 'editListing.dart';
import 'profile.dart';

String userId = '1';

class YourProduct extends StatefulWidget {
  // TODO Logga in med Google!!

  const YourProduct({super.key, required this.itemId});

  final int itemId;

  @override
  State<YourProduct> createState() => _YourProductState();
}

class _YourProductState extends State<YourProduct> {
  late Future<User> futureUser;
  Api _api = Api();
  int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User> fetchUser() async {
    final response =
        await http.get(Uri.parse('${_api.getApiHost()}/profilepage/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Listing'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditListing(),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: ProductListing(string: 'images/apple.jpg'),
                  ),
                  Align(
                      alignment: FractionalOffset.topRight,
                      child: ListingProfile(
                        futureUser: futureUser,
                      )),
                  //CardProduct(string: 'Hej'),
                ],
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: ItemName(
                    futureUser: futureUser,
                    itemId: widget.itemId,
                  ),
                ), //Hämta namnet från databasen
              ),
              Align(
                  alignment: FractionalOffset.topLeft,
                  child: ProductInfo(
                      futureUser: futureUser, itemId: widget.itemId)),
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
                    child: NumBids(string: '5'),
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

class ProductInfo extends StatelessWidget {
  ProductInfo({required this.futureUser, required this.itemId});

  final Future<User> futureUser;
  final int itemId;

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
            child: FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                List listings = snapshot.data!.listings;
                if (snapshot.hasData) {
                  return Text(
                    listings[itemId]['listing_description'].toString(),
                    style: style,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NumBids extends StatefulWidget {
  const NumBids({
    required this.string,
  });

  final String string;

  @override
  State<NumBids> createState() => _NumBidsState();
}

class _NumBidsState extends State<NumBids> {
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
            '7', //TODO: Kan inte ges som argument. Förmodligen pga stateful widget.
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
  String buttonName = "Delete";

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
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF685E),
        ),
        onPressed: () {
          setState(() {
            buttonName = "Deleted(?)";
          });
        },
        child: Text(
          buttonName,
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
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
    required this.futureUser,
  });

  final Future<User> futureUser;

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
            child: Image.asset(
              'images/woman.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0,
          ),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              Name(
                futureUser: futureUser,
              ),
              Text("80% (599)"), //TODO
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
        )
      ],
    );
  }
}

class Name extends StatelessWidget {
  // TODO se till att strängen int är längre än en rad för då blir rutan ful

  Name({required this.futureUser});

  final Future<User> futureUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<User>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!.userName.toString(),
            style: style,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class ItemName extends StatelessWidget {
  // TODO se till att strängen int är längre än en rad för då blir rutan ful

  ItemName({required this.futureUser, required this.itemId});

  final Future<User> futureUser;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<User>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List listings = snapshot.data!.listings;
          return Text(
            listings[itemId]['listing_name'].toString(),
            style: style,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
