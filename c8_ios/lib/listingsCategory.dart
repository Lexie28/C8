import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'specificItem.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingsPage extends StatefulWidget {
  final String category;

  const ListingsPage({required this.category});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  List<dynamic> listings = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    fetchListings();
  }

  Future<void> fetchListings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    final response = await http.get(Uri.parse(
        '${_api.getApiHost()}/listing?category=${widget.category}&exclude_user=$userId'));
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
        title: Text(widget.category),
      ),
      body: listings.isEmpty
          ? Center(child: Text('No listings in this category yet!'))
          : ListView.builder(
              itemCount: listings.length,
              itemBuilder: (BuildContext context, int index) {
                final listing = listings[index];
                return ListTile(
                  title: Text(listing['name']),
                  subtitle: Text(listing['description']),
                  trailing: Text(listing['category']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingDetailPage(
                            listingId: listing['id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
