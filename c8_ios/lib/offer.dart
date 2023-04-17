import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';
import 'otherProfile.dart';

class Offer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.1,
              bottom: MediaQuery.of(context).size.width * 0.07,
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => otherProfile(),
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'images/man.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text('You have offered a trade with Lars'),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 114, 185, 221),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.headphones),
                iconSize: MediaQuery.of(context).size.width * 0.2,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_upward),
                iconSize: MediaQuery.of(context).size.width * 0.1,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.apple),
                iconSize: MediaQuery.of(context).size.width * 0.2,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
