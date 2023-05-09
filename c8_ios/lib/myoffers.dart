import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'currentoffer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffersPage extends StatefulWidget {
  @override
  State<OffersPage> createState() => _OffersPageState();
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
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    try {
      final response =
          await http.get(Uri.parse('${_api.getApiHost()}/user/$userId/offers'));
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        _offersData = jsonData.map((offer) {
          final offerId = offer['bid_maker']['offer_id'];
          return {
            'offerId': offerId,
            'bidMaker': offer['bid_maker']['name'],
            'bidReceiver': offer['bid_receiver']['name'],
            'bidMakerListings': offer['bid_maker']['listings'],
            'bidReceiverListings': offer['bid_receiver']['listings']
          };
        }).toList();
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
          final offerId = _offersData[index]['offerId'];
          print(offerId);
          final bidMaker = _offersData[index]['bidMaker'];
          final bidReceiver = _offersData[index]['bidReceiver'];
          final bidMakerListings = _offersData[index]['bidMakerListings'];
          final bidReceiverListings = _offersData[index]['bidReceiverListings'];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CurrentOffer(bidId: offerId),
              ));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('$bidMaker',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Listings:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...bidMakerListings
                              .map((listing) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${listing['name']}'),
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
                          SizedBox(height: 8),
                          Text('$bidReceiver',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Listings:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...bidReceiverListings
                              .map((listing) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${listing['name']}'),
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
            ),
          );
        },
      ),
    );
  }
}
