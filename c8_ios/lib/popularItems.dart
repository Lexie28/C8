import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'secondmain.dart';
import '../toolbar.dart';
import 'clothingcategory.dart';
import 'otherProduct.dart';
import 'hometest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopularItems extends StatefulWidget {
  const PopularItems({super.key});

  @override
  State<PopularItems> createState() => _PopularItemsState();
}

class _PopularItemsState extends State<PopularItems> {
  late Future<List<dynamic>> _futureListings;

  @override
  void initState() {
    super.initState();
    _futureListings = fetchPopular();
  }

  Future<List<dynamic>> fetchPopular() async {
    final response = await http
        .get(Uri.parse('http://130.243.228.103:3000/listing/top5popular'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Popular Items'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<dynamic>>(
              future: _futureListings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listings = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listings.length,
                    itemBuilder: (BuildContext context, int index) {
                      final listing = listings[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OtherProduct(),
                                  ),
                                );
                              },
                              child: Item(string: listing['listing_name'])),

                          /*
                              ListTile(
                              title: Text(listing['listing_name']),
                              subtitle: Text(listing['listing_description']),
                              trailing: Text(listing['listing_category']),
                            ),
                            */
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Failed to fetch listings');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
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
