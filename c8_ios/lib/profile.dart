import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';

class Profile extends StatelessWidget {
  //Variabler som namn och bilder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        backgroundColor: Color(0xFFA2BABF),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // JOHN 1 ÄMNDRAR HÄR
                    builder: (BuildContext context) => Settings(),
                  ),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture
              Center(
                child: TextButton(
                    onPressed: () {
                      // TODO: Implement camera logic
                    },
                    child: const Text('Todo, hämta bild')),
              ),
              Center(child: Text(style: TextStyle(fontSize: 25), 'Name')),
              Center(child: Text('Location')),
              Center(child: Text('Amount of likes: xx')),

              Text('Your products'),
              Center(
                child: Row(
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
      ),
      bottomNavigationBar: toolbar(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          string,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
