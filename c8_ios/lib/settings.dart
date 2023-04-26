import 'package:flutter/material.dart';
import 'deleteProfile.dart';
import 'authentication.dart';
import 'main.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';


class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFFA2BABF),
        actions: [
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
      body: Center(
        child: Column(
          children: [
            SmallCard(
              string: 'Log out',
              color: Color.fromARGB(255, 123, 174, 156),
              onTap: () async {
                await Authentication.signOut(context: context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FirstPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DeleteProfile(),
                  ),
                );
              },
              child: SmallCard(
                string: 'Delete account',
                color: Color.fromARGB(255, 206, 96, 96),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final String string;
  final Color color;
  final Function()? onTap;

  const SmallCard({
    Key? key,
    required this.string,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            string,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}


/*
class SmallCard extends StatelessWidget {
  SmallCard({required this.string, required this.color});

  final String string;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.background,
      fontWeight: FontWeight.bold,
    );

    return Row(children: [
      Card(
        color: color,
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    ]);
  }
}*/
