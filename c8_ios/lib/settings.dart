import 'package:flutter/material.dart';
import 'deleteProfile.dart';

class Settings extends StatelessWidget {
  //Variabler som namn och bilder

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
                string: 'Log out', color: Color.fromARGB(255, 123, 174, 156)),
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
                  color: Color.fromARGB(255, 206, 96, 96)),
            )
          ],
        ),
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
}
