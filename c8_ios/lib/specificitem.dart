import 'dart:convert';
import 'package:c8_ios/yourProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/status.dart';
import 'api.dart';
import 'otherProfile.dart';
import 'createBid.dart';

class ListingDetailPage extends StatefulWidget {
  final String listingId;

  ListingDetailPage({required this.listingId});

  @override
  _ListingDetailPageState createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  late Future<Listing> futureListing;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    futureListing = fetchListingDetails();
  }

  Future<Listing> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/${widget.listingId}'));

    if (response.statusCode == 200) {
      return Listing.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = '';

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
              Align(
                alignment: FractionalOffset.topCenter,
                child: ProductListing(string: 'images/shoes.jpg'),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ProductName(
                    string: ListingName(
                  futureListing: futureListing,
                )),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ProductInfo(
                    string: ListingDesc(futureListing: futureListing)),
              ),
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: NumBids(
                        string: ListingBids(futureListing: futureListing)),
                  ),
                  FutureBuilder<Listing>(
                    future: futureListing,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> user = snapshot.data!.user;
                        userId = user['id'];
                        return Text('');
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    // bitbutton
                    child:
                        BidButton(listingId: widget.listingId, userId: userId),
                  )
                ],
              ),
              Container(
                color: Color.fromARGB(255, 233, 239, 240),
                child: Align(
                    alignment: FractionalOffset.topLeft,
                    child: ListingProfile(
                      name: UserName(
                        futureListing: futureListing,
                      ),
                      likes: Likes(
                        futureListing: futureListing,
                      ),
                      location: Location(futureListing: futureListing),
                    )),
              ),
            ],
          ),
        ),
      ),
    );

    /*
        } else if(snapshot.hasError){
          return Center(
            child: Text('Failed to fetch listing information'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );

        }*/
  }
  //),
  //bottomNavigationBar: toolbar(),
  //);
}
//}

class ProductName extends StatelessWidget {
  const ProductName({
    required this.string,
  });

  final ListingName string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0,
        MediaQuery.of(context).size.width * 0,
        MediaQuery.of(context).size.width * 0.02,
      ),
      child: string,
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    required this.string,
  });

  final ListingDesc string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
        //color: theme.colorScheme.onPrimary,
        );

    return FittedBox(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.03,
            MediaQuery.of(context).size.width * 0,
            MediaQuery.of(context).size.width * 0,
          ),
          //color: Color.fromARGB(255, 255, 255, 255),
          //elevation: 10,
          child: string,
        ),
      ),
    );
  }
}

class NumBids extends StatelessWidget {
  const NumBids({
    required this.string,
  });

  final ListingBids string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: [
          Text("Current bids: "),
          string,
        ],
      ),
    );
  }
}

class BidButton extends StatefulWidget {
  const BidButton({
    required this.listingId,
    required this.userId,
  });

  final String listingId;
  final String userId;

  @override
  State<BidButton> createState() => _BidButtonState();
}

class _BidButtonState extends State<BidButton> {
  String buttonName = "Make a bid";

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.2,
        MediaQuery.of(context).size.width * 0,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.05,
      ),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.height * 0.2,
      child: ElevatedButton.icon(
        label: Text(
          buttonName,
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.handshake_outlined,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA2BABF),

          //elevated btton background color
        ),
        onPressed: () {
          /*
          setState(() {
            buttonName = "Bidded";
          */
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CreateBid(
                listingId: widget.listingId,
                userId: widget.userId,
              ),
            ),
          );
        },
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
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.08,
      ),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.height * 0.35,
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
    required this.location,
  });

  final UserName name;
  final Likes likes;
  final Location location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "About the seller",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.2, color: Colors.white),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.width * 0.0,
                MediaQuery.of(context).size.width * 0,
              ),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.3,
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
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.01,
                    bottom: MediaQuery.of(context).size.width * 0.05),
                child: name),
          ],
        ),
        Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.0,
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.width * 0.0,
                  MediaQuery.of(context).size.width * 0,
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Container(
                  color: Color.fromARGB(93, 255, 254, 254),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          "Total likes:",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.12),
                              child: likes), //TODO
                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.04),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: Image.asset(
                              'images/like.png', //TODO
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          "Location:",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.07),
                              child: location), //TODO
                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: Image.asset(
                              'images/locationicon.png', //TODO
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class Listing {
  final String listingId;
  final Map<String, dynamic> user;
  final String listingName;
  final String listingDesc;
  final int listingBids;

  const Listing({
    required this.listingId,
    required this.user,
    required this.listingName,
    required this.listingDesc,
    required this.listingBids,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      listingId: json['id'],
      user: json['user'],
      listingName: json['name'],
      listingDesc: json['description'],
      listingBids: json['number_of_bids'],
    );
  }
}

class UserName extends StatelessWidget {
  UserName({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> user = snapshot.data!.user;
          return Text(
            user['name'].toString(),
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

class Location extends StatelessWidget {
  Location({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> user = snapshot.data!.user;
          return Text(user['user_location'].toString(),
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class Likes extends StatelessWidget {
  Likes({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> user = snapshot.data!.user;
          return Text(
            user['likes'].toString(),
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

class ListingName extends StatelessWidget {
  ListingName({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String productName = snapshot.data!.listingName;
          return Text(
            productName,
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

class ListingDesc extends StatelessWidget {
  ListingDesc({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String productName = snapshot.data!.listingDesc;
          return Text(productName,
              style: TextStyle(
                fontSize: 15,
              ));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class ListingBids extends StatelessWidget {
  ListingBids({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int productName = snapshot.data!.listingBids;
          return Text(
            productName.toString(),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055),
            textAlign: TextAlign.center,
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
