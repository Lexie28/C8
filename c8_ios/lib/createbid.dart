import 'dart:convert';
import 'package:c8_ios/otherProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBid extends StatefulWidget {
  final String listingId;
  final String userId;

  CreateBid({required this.listingId, required this.userId});

  @override
  _CreateBidState createState() => _CreateBidState();
}

class _CreateBidState extends State<CreateBid> {
  List<dynamic> myListingData = [];
  List<dynamic> theirListingData = [];
  List<int> selectedMyListingIds = [];
  List<int> selectedTheirListingIds = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    fetchListingData();
  }

  Future<void> fetchListingData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    print(userId);
    print(widget.userId);

    final myListingResponse =
        await http.get(Uri.parse('${_api.getApiHost()}/listing/user/$userId'));
    final theirListingResponse = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/user/${widget.userId}'));
    print(myListingResponse.body);
    print(theirListingResponse.body);
    if (myListingResponse.statusCode == 200 &&
        theirListingResponse.statusCode == 200) {
      setState(() {
        var myListingDecoded = jsonDecode(myListingResponse.body);
        var theirListingDecoded = jsonDecode(theirListingResponse.body);
        myListingData = myListingDecoded;
        theirListingData = theirListingDecoded;
      });
    } else {
      throw Exception('Failed to fetch listing data');
    }
  }

  void toggleMyListingSelection(int id) {
    setState(() {
      if (selectedMyListingIds.contains(id)) {
        selectedMyListingIds.remove(id);
      } else {
        selectedMyListingIds.add(id);
      }
    });
  }

  void toggleTheirListingSelection(int id) {
    setState(() {
      if (selectedTheirListingIds.contains(id)) {
        selectedTheirListingIds.remove(id);
      } else {
        selectedTheirListingIds.add(id);
      }
    });
  }

  Future<void> createBid() async {
    final data = {
      "user_making_offer": userId,
      "user_receiving_offer": widget.userId,
      "id_of_listings": [...selectedMyListingIds, ...selectedTheirListingIds],
    };
    final response = await http.post(
      Uri.parse('${_api.getApiHost()}/offer'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Bid created successfully, do something here
    } else {
      throw Exception('Failed to create bid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bid'),
      ),
      body: theirListingData.isEmpty || myListingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Theirs:', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: theirListingData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(theirListingData[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                theirListingData[index]['description']),
                            Text(theirListingData[index]['category']),
                          ],
                        ),
                        value: selectedTheirListingIds
                            .contains(theirListingData[index]['id']),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedTheirListingIds
                                  .add(theirListingData[index]['id']);
                            } else {
                              selectedTheirListingIds.remove(
                                  theirListingData[index]['id']);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Mine:', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: myListingData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(myListingData[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myListingData[index]['description']),
                            Text(myListingData[index]['category']),
                          ],
                        ),
                        value: selectedMyListingIds
                            .contains(myListingData[index]['id']),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedMyListingIds
                                  .add(myListingData[index]['id']);
                            } else {
                              selectedMyListingIds
                                  .remove(myListingData[index]['id']);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var data = {
                      "user_making_offer": userId,
                      "user_receiving_offer": widget.userId,
                      "id_of_listings": [
                        ...selectedMyListingIds,
                        ...selectedTheirListingIds
                      ],
                    };
                    var response = await http.post(
                      Uri.parse('${_api.getApiHost()}/offer/create'),
                      headers: <String, String>{
                        'Content-Type': 'application/json'
                      },
                      body: jsonEncode(data),
                    );
                    print(response.body);
                    // TODO: Handle response
                  },
                  child: Text('Create Bid'),
                ),
              ],
            ),
    );
  }
}


/*
class CreateBid extends StatefulWidget {
  final String listingId;
  final String userId;

  CreateBid({required this.listingId, required this.userId});

  @override
  _CreateBidState createState() => _CreateBidState();
}

class _CreateBidState extends State<CreateBid> {
  List<dynamic> myListingData = [];
  List<dynamic> theirListingData = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    fetchListingData();
  }

  Future<void> fetchListingData() async {
    final myListingResponse =
        await http.get(Uri.parse('${_api.getApiHost()}/listing/user/1'));
    final theirListingResponse = await http
        .get(Uri.parse('${_api.getApiHost()}/listing/user/${widget.userId}'));
    print(myListingResponse.body);
    print(theirListingResponse.body);
    if (myListingResponse.statusCode == 200 &&
        theirListingResponse.statusCode == 200) {
      setState(() {
        var myListingDecoded = jsonDecode(myListingResponse.body);
        var theirListingDecoded = jsonDecode(theirListingResponse.body);
        myListingData = myListingDecoded;
        theirListingData = theirListingDecoded;
      });
    } else {
      throw Exception('Failed to fetch listing data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bid'),
      ),
      body: theirListingData.isEmpty || myListingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Theirs:', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: theirListingData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(theirListingData[index]['listing_name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                theirListingData[index]['listing_description']),
                            Text(theirListingData[index]['listing_category']),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Mine:', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: myListingData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(myListingData[index]['listing_name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myListingData[index]['listing_description']),
                            Text(myListingData[index]['listing_category']),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
*/