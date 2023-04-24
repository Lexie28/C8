import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'specificitem.dart';
import 'api.dart';

class ListingsPage extends StatefulWidget {
  final String category;

  const ListingsPage({required this.category});

  @override
  _ListingsPageState createState() => _ListingsPageState();
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
    final response = await http.get(
        Uri.parse('${_api.getApiHost()}/listing/category/${widget.category}/1'));
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listings.length,
              itemBuilder: (BuildContext context, int index) {
                final listing = listings[index];
                return ListTile(
                  title: Text(listing['listing_name']),
                  subtitle: Text(listing['listing_description']),
                  trailing: Text(listing['listing_category']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingDetailPage(
                            listingId: listing['listing_id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}


/*
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
    final response = await http.get(
        Uri.parse('http://130.243.238.100:5000/listing/category/Clothing'));
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingDetailPage(
                            listingId: listing['listing_id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}*/