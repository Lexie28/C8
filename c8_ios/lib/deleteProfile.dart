import 'package:flutter/material.dart';
import 'settings.dart';
import 'deletion.dart';
import 'color.dart' as color;

class DeleteProfile extends StatelessWidget {
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: color.primary,
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.height * 0.1,
                  MediaQuery.of(context).size.height * 0.1,
                  MediaQuery.of(context).size.height * 0.1,
                  0),
              child: Text(
                'Are you sure want to delete your profile?',
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.1),
              child: Text(
                'This action is irreversible.',
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Button(
                      string: 'Cancel',
                      color: Color.fromARGB(255, 158, 158, 158)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Deletion(),
                      ),
                    );
                  },
                  child: Button(
                      string: 'Delete account',
                      color: Color.fromARGB(255, 206, 96, 96)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  Button({required this.string, required this.color});

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
