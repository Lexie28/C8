import 'package:c8_ios/myoffers.dart';
import 'package:c8_ios/signin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ws används inte?
//import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:web_socket_channel/io.dart';
// for access to jsonEncode to encode the data
//import 'homePage2.dart';

//Tovas sidor
import 'otherProduct.dart';
import 'otherProfile.dart';
import 'categories.dart';
import 'editprofile.dart';
import 'createprofile.dart';
import 'profile.dart';
import 'offers.dart';
import 'hometest.dart';
import 'createlisting.dart';

void main() {
  runApp(C8());
}

class C8 extends StatelessWidget {
  const C8({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Eight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3D4640)),
      ),
      home: FirstPage(),
    );
  }
}

class MyBottomNavigationbar extends StatefulWidget {
  const MyBottomNavigationbar({super.key});

  @override
  State<MyBottomNavigationbar> createState() => _MyBottomNavigationbarState();
}

class _MyBottomNavigationbarState extends State<MyBottomNavigationbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage3(),
    CreateListingPage(),
    OffersPage(),
    Profile(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFA2BABF),
        selectedItemColor: Color.fromARGB(255, 80, 102, 106),
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'New listing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cached),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'My profile',
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 233, 247, 249),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.height * 0.1,
              MediaQuery.of(context).size.height * 0.2,
              MediaQuery.of(context).size.height * 0.1,
              MediaQuery.of(context).size.height * 0.1,
            ),
            child: Card(
              color: Color.fromARGB(255, 160, 200,
                  207), // Use hexadecimal color code for consistency
              elevation: 4, // Add elevation to create a shadow effect
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Round the corners of the card
              ),
              child: Padding(
                padding: EdgeInsets.all(45),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the content vertically
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Use a readable text color
                      ),
                    ),
                    Text(
                      'to',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Use a readable text color
                      ),
                    ),
                    Text(
                      'Circle 8',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Use a readable text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("Button pressed");
              setState(() {
                _isSigningIn = true;
              });

              auth.User? user =
                  await Authentication.signInWithGoogle(context: context);

              setState(() {
                _isSigningIn = false;
              });

              if (user != null) {
                print(user);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("uid", user.uid);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBottomNavigationbar()),
                );
              }
            },
            child: FutureBuilder(
              future: Authentication.initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return GoogleSignInButton();
                }
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 174, 0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () async {
              print("Next button pressed");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationbar()),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}