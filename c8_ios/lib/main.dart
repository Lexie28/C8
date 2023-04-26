import 'package:c8_ios/myoffers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
  final String userId = '1';

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
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //color: Color.fromARGB(255, 233, 247, 249),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage('images/skogberg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.3,
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Text(
                  'Circle 8',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    // Use a readable text color
                  ),
                ),
              ),
            ),
            /*
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
              */
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyBottomNavigationbar(),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/googleLogo.png',
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.06,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*
              child: Card(
                color: Color.fromARGB(255, 160, 200, 207),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/googleLogo.png',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.05,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              */
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreateProfile(),
                  ),
                );
              },
              child: Card(
                color: Color.fromARGB(0, 244, 238, 238),
                elevation: 1,
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0,
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.width * 0,
                  MediaQuery.of(context).size.width * 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 254, 254),
                            fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                                color: Color.fromARGB(255, 146, 183, 247),
                                fontSize: 18),
                          )
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.59,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0,
              ),
              child: Text('Circle 8 2023',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

/*Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (context) => MyAppState(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Circle Eight',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 112, 167, 158)),
      ),
      home: HomePage(),
    ),
  );
}*/
