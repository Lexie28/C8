import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'api.dart';
import 'otherProfile.dart';
import 'createBid.dart';
import 'profile.dart';
import 'color.dart' as color;

class ListingDetailPage extends StatefulWidget {
  final String listingId;

  ListingDetailPage({required this.listingId});

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  late Future<Listing> futureListing;
  late String userId = '';
  late String myID = '';
  String imagePath = 'loading.png';
  String profilePicturePath = 'loading.png';
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    futureListing = fetchListingDetails();
  }

  Future<Listing> fetchListingDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final myId = prefs.getString('uid');

    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/${widget.listingId}'));

    if (response.statusCode == 200) {
      Listing listing = Listing.fromJson(jsonDecode(response.body));

      setState(() {
        userId = listing.user['id'];
        myID = myId!;
        imagePath = listing.listingPic.toString();
        fetchPP(userId);
      });

      return listing;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> fetchPP(String userId) async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$userId'));

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));

      setState(() {
        profilePicturePath = user.profilePicturePath;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: color.primary,
        title: Text('Listing'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: FractionalOffset.topCenter,
                child: ListingImage(
                  imagePath: imagePath,
                ),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ListingName(
                  futureListing: futureListing,
                ),
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
                  Align(
                      alignment: FractionalOffset.center,
                      // bitbutton
                      child: userId != myID
                          ? BidButton(
                              listingId: widget.listingId, userId: userId)
                          : Text('hej'))
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
                      id: userId,
                      likes: Likes(
                        futureListing: futureListing,
                      ),
                      location: Location(futureListing: futureListing),
                      profilePicturePath: profilePicturePath,
                    )),
              ),
            ],
          ),
        ),
      ),
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
        color: color.primary
        );

    return FittedBox(
      child: SizedBox(
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
          backgroundColor: color.primary,

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

class ListingImage extends StatelessWidget {
  const ListingImage({
    required this.imagePath,
  });

  final String imagePath;

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
        child: Image.network(
          'https://circle8.s3.eu-north-1.amazonaws.com/$imagePath',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ListingProfile extends StatelessWidget {
  const ListingProfile(
      {required this.name,
      required this.id,
      required this.likes,
      required this.location,
      required this.profilePicturePath});

  final UserName name;
  final String id;
  final Likes likes;
  final Location location;
  final String profilePicturePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
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
                        builder: (BuildContext context) =>
                            OtherProfile(userId: id),
                      ),
                    );
                  },
                  child: Image.network(
                    'https://circle8.s3.eu-north-1.amazonaws.com/$profilePicturePath',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.01,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: name),
          ],
        ),
        Column(
          children: [
            SizedBox(
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
                              child: likes),
                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.04),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: Image.asset(
                              'images/like.png',
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
            SizedBox(
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
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                    Row(children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07),
                          child: location),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://www.google.com/maps/search/?api=1&query=${location.toString()}',
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.07,
                          child: Image.asset(
                            'images/locationicon.png', //TODO
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
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
  final String listingPic;

  const Listing({
    required this.listingId,
    required this.user,
    required this.listingName,
    required this.listingDesc,
    required this.listingBids,
    required this.listingPic,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      listingId: json['id'],
      user: json['user'],
      listingName: json['name'],
      listingDesc: json['description'],
      listingBids: json['number_of_bids'],
      listingPic: json['image_path'],
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
      color: color.primary,
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
      color: color.primary,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> user = snapshot.data!.user;
          return Text(user['location'].toString(),
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
          return Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                productName,
                style: style,
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

class ListingDesc extends StatelessWidget {
  ListingDesc({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: color.primary,
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
      color: color.primary,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int productBids = snapshot.data!.listingBids;
          return Text(
            productBids.toString(),
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

class ListingPic extends StatelessWidget {
  ListingPic({required this.futureListing});

  final Future<Listing> futureListing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: color.primary,
    );

    return FutureBuilder<Listing>(
      future: futureListing,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String productName = snapshot.data!.listingPic;
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
