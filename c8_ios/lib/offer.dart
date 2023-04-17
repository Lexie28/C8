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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top:MediaQuery.of(context).size.width * 0.01,
                bottom:MediaQuery.of(context).size.width * 0.07,
                left:MediaQuery.of(context).size.width * 0.2,
                right:MediaQuery.of(context).size.width * 0.2
              ),
              child: ElevatedButton( 
                onPressed: () { 
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => otherProfile(),
                    )
                  );
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
              constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width *0.5,
              minHeight: MediaQuery.of(context).size.height *0.2,

              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 114, 185, 221),
                shape: BoxShape.rectangle, 
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.headphones),
                    iconSize: MediaQuery.of(context).size.width *0.12,
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.arrow_upward),
                    iconSize: MediaQuery.of(context).size.width *0.1,
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.apple),
                    iconSize: MediaQuery.of(context).size.width *0.12,
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.close_outlined),
                    iconSize: MediaQuery.of(context).size.width *0.2,
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.add_box_outlined),
                    iconSize: MediaQuery.of(context).size.width *0.09,
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.check_circle_outline),
                    iconSize: MediaQuery.of(context).size.width *0.2,
                  ),
                ],
              )
            )
          ],
        ),
      ),
   );
  }
}
