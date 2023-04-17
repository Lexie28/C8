import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';
import 'deleteProfile.dart';

class MakeBid extends StatelessWidget {
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );
    final style2 = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Make bid'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Select your bidding',
                  style: style,
                ),
              ),
            ],
          ),
          // TODO få in rätt user
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  // TODO få in rätt user
                  'Lars',
                  style: style2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.4,
                color: Color.fromARGB(255, 211, 211, 211),
              )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  'Your',
                  style: style2,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallCard(
                  string: 'Cancel', color: Color.fromARGB(255, 211, 211, 211)),
              SmallCard(string: 'Ok', color: Color.fromARGB(255, 165, 206, 146))
            ],
          )
        ],
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  SmallCard({required this.string, required this.color});

  final String string;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08),
      child: Row(children: [
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
      ]),
    );
  }
}
