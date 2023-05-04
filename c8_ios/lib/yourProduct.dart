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
        backgroundColor: Color(0xFFA2BABF),
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
              Row(
                children: [
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: ProductListing(string: imagePath),
                  ),
                  Align(
                      alignment: FractionalOffset.topRight,
                      child: ListingProfile(
                        futureUser: futureUser,
                        picturePath: profilePicturePath,
                      )),
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
                    itemId: widget.itemIndex,
                  ),
                ),
              ),
              Align(
                  alignment: FractionalOffset.topLeft,
                  child: ProductInfo(
                      futureUser: futureUser, itemId: widget.itemIndex)),
              Align(
                alignment: FractionalOffset.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
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
              Align(
                alignment: FractionalOffset.topLeft,
                child: NumBids(
                  futureUser: futureUser,
                  itemId: widget.itemIndex,
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
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
      ),
      color: theme.colorScheme.primary,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: MediaQuery.of(context).size.width * 0.04,
          ),
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
          )),
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
        child: Image.network(
          'https://circle8.s3.eu-north-1.amazonaws.com/$string',
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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.0,
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.network(
              'https://circle8.s3.eu-north-1.amazonaws.com/$picturePath',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.04,
            MediaQuery.of(context).size.width * 0.0,
          ),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              Name(
                futureUser: futureUser,
              ),
              Text("80% (599)"), //TODO
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.07,
                child: Image.asset(
                  'images/like.png',
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
            listings[itemId]['name'].toString(),
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
