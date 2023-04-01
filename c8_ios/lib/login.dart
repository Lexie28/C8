library login;
import 'package:flutter/material.dart';

import 'main.dart';

class LogIn extends StatelessWidget {
  // TODO Logga in med Google!!

  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 200,
            ),
            BigCard(string: 'Placeholder for Google login')
          ]),
        ));
  }
}