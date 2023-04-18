import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListingsPage extends StatefulWidget {
  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  List<dynamic> listings = [];

  @override
  void initState() {
    super.initState();
    fetchListings();
  }

  Future<void> fetchListings() async {
    final response = await http
        .get(Uri.parse('http://130.243.236.34:3000/listing/category/Fashion'));
    if (response.statusCode == 200) {
      setState(() {
        listings = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing'),
      ),
      body: listings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listings.length,
              itemBuilder: (BuildContext context, int index) {
                final listing = listings[index];
                return ListTile(
                  title: Text(listing['listing_name']),
                  subtitle: Text(listing['listing_description']),
                  trailing: Text(listing['listing_category']),
                );
              },
            ),
    );
  }
}

 /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listings'),
      ),
      body: ListView.builder(
        itemCount: listings.length,
        itemBuilder: (BuildContext context, int index) {
          final listing = listings[index];
          return ListTile(
            title: Text(listing['listing_name']),
            subtitle: Text(listing['listing_description']),
            trailing: Text(listing['listing_category']),
          );
        },
      ),
    );
  }
}*/

/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';

import 'package:http/http.dart' as http;

class TestingHttp extends StatefulWidget {
  @override
  State<TestingHttp> createState() => _TestingHttpState();
}

class _TestingHttpState extends State<TestingHttp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestingHttp'),
        backgroundColor: Color(0xFFA2BABF),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ColorExp(
                string: 'your bids', color: Color.fromARGB(255, 74, 118, 249)),
          ],
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ColorExp extends StatelessWidget {
  ColorExp({required this.string, required this.color});

  final String string;
  final Color color;

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
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}*/
