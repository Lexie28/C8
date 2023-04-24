import 'package:c8_ios/main.dart';
import 'package:flutter/material.dart';

class Deletion extends StatelessWidget {
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.height * 0.1,
                MediaQuery.of(context).size.height * 0.35,
                MediaQuery.of(context).size.height * 0.1,
                MediaQuery.of(context).size.height * 0.1,
              ),
              child: Text(
                'Your account has been deleted.',
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FirstPage(),
                  ),
                );
              },
              child: Card(
                color: Color.fromARGB(255, 162, 226, 239),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                  child: Text(
                    'Go back to start page',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
