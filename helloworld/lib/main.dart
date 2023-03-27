import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String buttonName = 'Click';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hej elsa hej'),
        ),
        body: Center(
          child: currentIndex == 0 ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      buttonName = 'Clicked';
                    });
                  },
                  child: Text(buttonName),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      buttonName = 'Clicked';
                    });
                  },
                  child: Text(buttonName),
                )
              ],
            ),
          ) : Image.asset('images/nedladdning.jpg') ,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
