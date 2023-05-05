import 'package:flutter/material.dart';
import 'api.dart';
import 'specificitem.dart';
import 'profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtherProfile extends StatefulWidget {
  OtherProfile({required this.userId});

  final String userId;

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  late Future<User> futureUser;
  String userName = '';
  String location = '';
  String profilePicturePath = 'loading.png';

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Api _api = Api();

  Future<User> fetchUser() async {
    print(widget.userId);
    final response = await http.get(
        Uri.parse('${_api.getApiHost()}/pages/profilepage/${widget.userId}'));
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));

      setState(() {
        userName = user.userName;
        location = user.location;
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
        title: Text('Circle Eight'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: FractionalOffset.topCenter,
                child: ProfilePicture(
                  picturePath: profilePicturePath,
                ),
              ),
              Align(
                alignment: FractionalOffset.topCenter,
                child: ProfileName(string: userName, location: location),
              ),
      
              // Alla produkter!!
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
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 48.0) /
                                  3, // calculate the width of each item based on the screen width and the spacing between items
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ListingDetailPage(
                                              listingId: listings[i]['id']),
                                    ),
                                  );
                                },
                                child: Item(
                                  string: listings[i]['name'],
                                  picturePath: listings[i]['image_path'],
                                ),
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
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.18,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0,
      ),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          'https://circle8.s3.eu-north-1.amazonaws.com/$picturePath',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({
    required this.string,
    required this.location,
  });

  final String string;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0,
      ),
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          Text(
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07),
            string,
          ),
          Text(location),
          Text(
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              "50% (12)"),
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
    );
  }
}

class ProductProfile extends StatelessWidget {
  const ProductProfile({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.07,
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.02,
      ),
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.height * 0.17,
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
