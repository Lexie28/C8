import 'package:c8_ios/api.dart';
import 'package:c8_ios/myoffers.dart';
import 'package:c8_ios/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';
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
    HomePage(),
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
  Api _api = Api();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //color: Color.fromARGB(255, 233, 247, 249),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/holdingplant.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.45,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.34,
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Text(
                  'Circle 8',
                  style: GoogleFonts.kalam(
                    //kalam
                    textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.065,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
            /*
              GestureDetector(
                onTap: () async {
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
                  }
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
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 254, 254),
                              fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Sign in',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 146, 183, 247),
                                  fontSize: 18),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              */
            Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0.55,
                MediaQuery.of(context).size.width * 0,
                MediaQuery.of(context).size.width * 0,
              ),
              child: Text(
                'Circle 8 2023',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
