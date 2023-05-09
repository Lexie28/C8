import 'package:flutter/material.dart';
import 'listingsCategory.dart';
//import 'package:provider/provider.dart';
//import 'secondmain.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Circle Eight'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ListingsPage(category: 'Clothing'),
                  ));
                },
                child:
                    Category(string: 'Clothing', icon: 'images/shirticon.png'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ListingsPage(category: 'Books'),
                  ));
                },
                child: Category(
                  string: 'Books',
                  icon: 'images/bookicon.png',
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Beauty'),
                    ));
                  },
                  child: Category(
                    string: 'Beauty',
                    icon: 'images/beautyicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Accessories'),
                    ));
                  },
                  child: Category(
                    string: 'Accessories',
                    icon: 'images/accessioriesicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Collectables'),
                    ));
                  },
                  child: Category(
                    string: 'Collectables',
                    icon: 'images/collectablesicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Furniture'),
                    ));
                  },
                  child: Category(
                    string: 'Furniture',
                    icon: 'images/furnitureicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Electronics'),
                    ));
                  },
                  child: Category(
                      string: 'Electronics',
                      icon: 'images/electronicsicon.png')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Houseware'),
                    ));
                  },
                  child: Category(
                    string: 'Houseware',
                    icon: 'images/housewareicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Sports'),
                    ));
                  },
                  child: Category(
                    string: 'Sports',
                    icon: 'images/sportsicon.png',
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Other'),
                    ));
                  },
                  child: Category(
                    string: 'Other',
                    icon: 'images/othericon.png',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    required this.string,
    required this.icon,
  });

  final String string;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );
    return Card(
      color: Color.fromARGB(255, 255, 255, 255),
      elevation: 10,
      child: Align(
        alignment: FractionalOffset.center,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
          child: Row(
            children: [
              Image.asset(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2,
                  icon),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(string, style: style),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
