import 'dart:io';

import 'package:c8_ios/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';
import 'yourProduct.dart';

class Profile extends StatelessWidget {
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Your Profile'),
        backgroundColor: Color(0xFFA2BABF),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditProfile(),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile picture
            Center(
                child: TextButton(
              onPressed: () {
                // TODO: Implement camera logic
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.08),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: Image.asset(
                    'images/woman.jpg',
                  ),
                ),
              ),
            )),
            
            Center(child: Text(
              style: style, 'Name')),
            Center(child: Text('Location')),
            Center(child: Text('Amount of likes: xx')),

            Text('Your products'),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => YourProduct(),
                        ),
                      );
                    },
                    child: ProfileProducts(
                      string: 'a product',
                    ),
                  ),
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileProducts(
                    string: 'a product',
                  ),
                  ProfileProducts(
                    string: 'a product',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ProfileProducts extends StatelessWidget {
  final String string;

  const ProfileProducts({
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        string,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
