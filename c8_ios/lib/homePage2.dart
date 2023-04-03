import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../main.dart';
import '../toolbar.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle 8'),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Color.fromARGB(255, 162, 186, 191),
      ),
      bottomNavigationBar: toolbar(),
      body: Center(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Här är alla widgetar
          Header(string: 'Categories'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Category(string: 'Clothes'),
              SizedBox(width: 10),
              Category(string: 'Shoes'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Category(string: 'Food'),
              SizedBox(width: 10),
              Category(string: 'All categories'),
            ],
          ),
          SizedBox(height: 10),
          Header(string: 'Popular items'),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Item(string: 'Shoes'),
            SizedBox(width: 10),
            Item(string: 'Flaming tequila'),
            SizedBox(width: 10),
            Item(string: 'Product name'),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Item(string: 'Product name'),
            SizedBox(width: 10),
            Item(string: 'Product name'),
            SizedBox(width: 10),
            Item(string: 'Product name'),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 50),
            Item(string: 'Product name'),
            SizedBox(width: 10),
            Item(string: 'Product name'),
            SizedBox(width: 10),
            Item(string: 'Product name')
          ]),
        ]),
      )),
    );
  }
}

class Item extends StatelessWidget {
  Item({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.2,
      color: Color.fromARGB(255, 195, 195, 195),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.asset('assets/shoes.png', fit: BoxFit.cover),
          ),
          Text(string),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({required this.string});

  final String string;

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
      child: SizedBox(
        height: 70,
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

class Category extends StatelessWidget {
  Category({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.inversePrimary,
      elevation: 5,
      child: SizedBox(
        height: 80,
        width: 150,
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
