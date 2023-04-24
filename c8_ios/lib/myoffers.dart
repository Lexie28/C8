import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<dynamic> _offersData = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _getOffers();
  }

  Future<void> _getOffers() async {
    try {
      final response =
          await http.get(Uri.parse('${_api.getApiHost()}/offer/offers/1'));
      final jsonData = jsonDecode(response.body);
      setState(() {
        _offersData = jsonData;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
      ),
      body: ListView.builder(
        itemCount: _offersData.length,
        itemBuilder: (context, index) {
          final bidMaker = _offersData[index]['bid_maker'];
          final bidReceiver = _offersData[index]['bid_receiver'];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('Bid Maker', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        //Text('User ID: ${bidMaker['user_id']}'),
                        Text('${bidMaker['user_name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Listings:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...bidMaker['listings']
                            .map((listing) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text('Listing ID: ${listing['listing_id']}'),
                                    Text('Listing: ${listing['listing_name']}'),
                                    //Text('Description: ${listing['listing_description']}'),
                                    SizedBox(height: 8),
                                  ],
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('Bid Receiver', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        //Text('User ID: ${bidReceiver['user_id']}'),
                        Text('${bidReceiver['user_name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Listings:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...bidReceiver['listings']
                            .map((listing) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text('Listing ID: ${listing['listing_id']}'),
                                    Text('Listing: ${listing['listing_name']}'),
                                    //Text('Description: ${listing['listing_description']}'),
                                    SizedBox(height: 8),
                                  ],
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

               



/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class OffersPage extends StatefulWidget {
  //final int offerId;

  //OffersPage({required this.offerId});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<dynamic> _offersData = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _getOffers();
  }

  Future<void> _getOffers() async {
    try {
      final response =
          await http.get(Uri.parse('${_api.getApiHost()}/offer/offers/1'));
      final jsonData = jsonDecode(response.body);
      setState(() {
        _offersData = jsonData;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
      ),
      body: ListView.builder(
        itemCount: _offersData.length,
        itemBuilder: (context, index) {
          final bidMaker = _offersData[index]['bid_maker'];
          final bidReceiver = _offersData[index]['bid_receiver'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Bid Maker'),
              SizedBox(height: 8),
              Text('User ID: ${bidMaker['user_id']}'),
              Text('User Name: ${bidMaker['user_name']}'),
              SizedBox(height: 8),
              Text('Listings:'),
              ...bidMaker['listings']
                  .map((listing) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Listing ID: ${listing['listing_id']}'),
                          Text('Listing Name: ${listing['listing_name']}'),
                          Text(
                              'Listing Description: ${listing['listing_description']}'),
                          SizedBox(height: 8),
                        ],
                      ))
                  .toList(),
              SizedBox(height: 16),
              Text('Bid Receiver'),
              SizedBox(height: 8),
              Text('User ID: ${bidReceiver['user_id']}'),
              Text('User Name: ${bidReceiver['user_name']}'),
              SizedBox(height: 8),
              Text('Listings:'),
              ...bidReceiver['listings']
                  .map((listing) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Listing ID: ${listing['listing_id']}'),
                          Text('Listing Name: ${listing['listing_name']}'),
                          Text(
                              'Listing Description: ${listing['listing_description']}'),
                          SizedBox(height: 8),
                        ],
                      ))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}*/