import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:c8_ios/editprofile.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'yourProduct.dart';
import 'api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;
import 'package:c8_ios/editprofile.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'yourProduct.dart';
import 'dart:convert';
import 'api.dart';
import 'inloggadUser.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> futureUser;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final response =
        await http.get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  //Variabler som namn och bilder
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Your Profile'),
        backgroundColor: Color(0xFFA2BABF),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditProfile(),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Settings(),
                  ),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile picture
            Center(
                child: TextButton(
              onPressed: () {
                // TODO: Implement camera logic
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.08),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: Image.asset(
                    'images/woman.jpg',
                  ),
                ),
              ),
            )),

            Center(
              child: FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        style: style, snapshot.data!.userName.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),

            Center(
              child: FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.location.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Amount of likes: '),
              FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.likes.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ]),

            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Text(style: style, 'Your products:'),
            ),

            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listings = snapshot.data!.listings;

                  return Wrap(
                      spacing: 16.0, // set the horizontal spacing between items
                      runSpacing:
                          16.0, // set the vertical spacing between items
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
                                        YourProduct(itemIndex: i),
                                  ),
                                );
                              },
                              child: Item(string: listings[i]['name']),
                            ),
                          ),
                      ]);
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

class ProfileProducts extends StatelessWidget {
  final String string;

  const ProfileProducts({
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        string,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class User {
  final String userId;
  final String userName;
  final String location;
  final int likes;
  final int dislikes;
  final List listings;

  const User({
    required this.userId,
    required this.userName,
    required this.location,
    required this.likes,
    required this.dislikes,
    required this.listings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      userName: json['name'],
      location: json['location'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      listings: json['listings'],
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