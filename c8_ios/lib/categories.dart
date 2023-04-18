import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'secondmain.dart';
import 'clothingcategory.dart';

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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListingsPage(),
                      ),
                    );
                },
                child: Category(string: 'Clothing')),
              Category(string: 'Books'),
              Category(string: 'Beauty'),
              Category(string: 'Accessories'),
              Category(string: 'Collectables'),
              Category(string: 'Furniture'),
              Category(string: 'Electronics'),
              Category(string: 'Houseware'),
              Category(string: 'Sport'),
              Category(string: 'Other'),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 1,
      child: Card(
        color: theme.colorScheme.primary,
        elevation: 10,
        child: Align(
          alignment: FractionalOffset.center,
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}
