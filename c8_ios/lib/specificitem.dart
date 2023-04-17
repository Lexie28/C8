import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ListingDetailPage extends StatefulWidget {
  final String listingId;

  ListingDetailPage({required this.listingId});

  @override
  _ListingDetailPageState createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  Map<String, dynamic> listing = {};
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    fetchListingDetails();
  }

  Future<void> fetchListingDetails() async {
    final response = await http.get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
            listing = decoded;
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['listing_name'] ?? ''),
      ),
      body: listing.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text('Listing Name'),
                  subtitle: Text(listing['listing_name']),
                ),
                ListTile(
                  title: Text('Listing Description'),
                  subtitle: Text(listing['listing_description']),
                ),
                ListTile(
                  title: Text('Listing Category'),
                  subtitle: Text(listing['listing_category']),
                ),
                ListTile(
                  title: Text('User Name'),
                  subtitle: Text(listing['user']['user_name']),
                ),
                ListTile(
                  title: Text('User Location'),
                  subtitle: Text(listing['user']['user_location']),
                ),
              ],
            ),
    );
  }
}


/*
class _ListingDetailPageState extends State<ListingDetailPage> {
  Map<String, dynamic> listing = {};
  Api _api = Api();
  List<Widget> listTileWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchListingDetails();
  }

  Future<void> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            listing = decoded[0];
          } else {
            throw Exception('Failed to fetch listing details');
          }
        } else {
          throw Exception('Failed to fetch listing details');
        }

        // Retrieve user information from the API response
        final user = listing['user'];
        final userName = user['user_name'];
        final userLocation = user['user_location'];

        // Add the user information to the ListTile widgets
        listTileWidgets = [
          ListTile(
            title: Text('User ID'),
            subtitle: Text(listing['user_id'].toString()),
          ),
          ListTile(
            title: Text('Listing Name'),
            subtitle: Text(listing['listing_name']),
          ),
          ListTile(
            title: Text('Listing Description'),
            subtitle: Text(listing['listing_description']),
          ),
          ListTile(
            title: Text('Listing Category'),
            subtitle: Text(listing['listing_category']),
          ),
          ListTile(
            title: Text('User Name'),
            subtitle: Text(userName),
          ),
          ListTile(
            title: Text('User Location'),
            subtitle: Text(userLocation),
          ),
        ];
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['listing_name'] ?? ''),
      ),
      body: listing.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: listTileWidgets,
            ),
    );
  }
}*/

  /*

  Future<void> fetchListingDetails() async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/get/${widget.listingId}'));
    if (response.statusCode == 200) {
      setState(() {
        var decoded = jsonDecode(response.body);
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            listing = decoded[0];
          } else {
            throw Exception('Failed to fetch listing details');
          }
        } else {
          throw Exception('Failed to fetch listing details');
        }
      });
    } else {
      throw Exception('Failed to fetch listing details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing['listing_name'] ?? ''),
      ),
      body: listing.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text('User ID'),
                  subtitle: Text(listing['user_id'].toString()),
                ),
                ListTile(
                  title: Text('Listing Name'),
                  subtitle: Text(listing['listing_name']),
                ),
                ListTile(
                  title: Text('Listing Description'),
                  subtitle: Text(listing['listing_description']),
                ),
                ListTile(
                  title: Text('Listing Category'),
                  subtitle: Text(listing['listing_category']),
                ),
              ],
            ),
    );
  }
}*/
