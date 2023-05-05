import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api.dart';
import 'editListing.dart';
import 'main.dart';
import 'profile.dart';

class YourProduct extends StatefulWidget {
  const YourProduct({super.key, required this.itemIndex});

  final int itemIndex;

  @override
  State<YourProduct> createState() => _YourProductState();
}

class _YourProductState extends State<YourProduct> {
  late Future<User> futureUser;
  Api _api = Api();

  String itemId = '';
  String imagePath = 'loading.png';
  String profilePicturePath = 'loading.png';

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$userId'));

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));

      setState(() {
        itemId = user.listings[widget.itemIndex].toString();
        imagePath = user.listings[widget.itemIndex]['image_path'].toString();
        profilePicturePath = user.profilePicturePath;
      });

      return user;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 142, 219, 250),
        title: Text('Listing'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditListing(itemId: itemId)));
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: FractionalOffset.topCenter,
                child: ProductListing(imagePath: imagePath),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ListingName(
                  futureUser: futureUser,
                  itemId: widget.itemIndex,
                ),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: ProductInfo(
                    futureUser: futureUser, itemId: widget.itemIndex),
              ),
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: NumBids(
                      futureUser: futureUser,
                      itemId: widget.itemIndex,
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    // bitbutton
                    //child: BidButton(),
                  )
                ],
              ),
              Container(
                color: Color.fromARGB(255, 233, 239, 240),
                child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: ListingProfile(
                    futureUser: futureUser,
                    picturePath: profilePicturePath,
                  ),
                ),
              ),
              FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List listings = snapshot.data!.listings;
                    itemId = listings[widget.itemIndex]['id'];
                    return DeleteProduct(itemId: itemId);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
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
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
        ),
        color: theme.colorScheme.onSecondary,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List listings = snapshot.data!.listings;
                return Text(
                  listings[itemId]['description'].toString(),
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
    );
  }
}

class NumBids extends StatelessWidget {
  const NumBids({
    required this.futureUser,
    required this.itemId,
  });

  final Future<User> futureUser;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(

      child: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List listings = snapshot.data!.listings;
            return Text(
              listings[itemId]['number_of_bids'].toString(),
              style: style,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class BidButton extends StatefulWidget {
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
        onPressed: () {},
      ),
    );
  }
}

class DeleteProduct extends StatelessWidget {
  const DeleteProduct({required this.itemId});

  final String itemId;

  Future<void> _deleteProduct(BuildContext context) async {
    final api = Api();
    final url = '${api.getApiHost()}/listing/$itemId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete this product?'),
            content: Text('This action cannot be undone.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteProduct(context);
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      ),
      icon: Icon(color: Colors.red, Icons.delete),
    );
  }
}

class ProductListing extends StatelessWidget {
  const ProductListing({
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
  const ListingProfile({
    required this.futureUser,
    required this.picturePath,
  });

  final Future<User> futureUser;
  final String picturePath;

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
                  onTap: () {},
                  child: Image.network(
                    'https://circle8.s3.eu-north-1.amazonaws.com/$picturePath',
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
              child: Name(
                futureUser: futureUser,
              ),
            ),
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
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Name extends StatelessWidget {
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

class ListingName extends StatelessWidget {
  ListingName({required this.futureUser, required this.itemId});

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
          return Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: Text(
                listings[itemId]['name'].toString(),
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
