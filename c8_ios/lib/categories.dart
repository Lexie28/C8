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
                  child: Category(string: 'Clothing')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Books'),
                    ));
                  },
                  child: Category(string: 'Books')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Beauty'),
                    ));
                  },
                  child: Category(string: 'Beauty')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Accessories'),
                    ));
                  },
                  child: Category(string: 'Accessories')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Collectables'),
                    ));
                  },
                  child: Category(string: 'Collectables')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Furniture'),
                    ));
                  },
                  child: Category(string: 'Furniture')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Electronics'),
                    ));
                  },
                  child: Category(string: 'Electronics')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Houseware'),
                    ));
                  },
                  child: Category(string: 'Houseware')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Sports'),
                    ));
                  },
                  child: Category(string: 'Sports')),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListingsPage(category: 'Other'),
                    ));
                  },
                  child: Category(string: 'Other')),
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
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Align(
        alignment: FractionalOffset.center,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}
