import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
//import 'package:english_words/english_words.dart';
//import 'dart:async';
// for access to jsonEncode to encode the data
import 'homePage2.dart';
//Tovas sidor
import 'otherProduct.dart';
import 'otherProfile.dart';
import 'categories.dart';
import 'addlisting.dart';
import 'editprofile.dart';
import 'createprofile.dart';
import 'profile.dart';
import 'offers.dart';
import 'hometest.dart';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 112, 167, 158)),
      ),
      home: MyBottomNavigationbar(),
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
    AddListing(),
    Offers(),
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
        selectedItemColor: Colors.blueAccent,
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
