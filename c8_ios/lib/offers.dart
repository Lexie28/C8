import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';

class Offers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: Color(0xFFA2BABF),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ColorExp(
                string: 'your bids', color: Color.fromARGB(255, 74, 118, 249)),
          ],
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ColorExp extends StatelessWidget {
  ColorExp({required this.string, required this.color});

  final String string;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.tertiary),
      ),
      color: theme.colorScheme.tertiary,
      elevation: 10,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}
