import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';


class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List _offersList = [];
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    final response =
        await http.get(Uri.parse('${_api.getApiHost()}/offer/offers/1'));

    if (response.statusCode == 200) {
      setState(() {
        _offersList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load offers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: _offersList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _offersList.length,
              itemBuilder: (BuildContext context, int index) {
                final bid = _offersList[index];
                final listings = bid['listings'];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Bid ID: ${bid['bid_id']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      for (final listing in listings)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ID: ${listing['listing']['user_id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Listing Name: ${listing['listing']['listing_name']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              if (listing['other_user']['user_id'] != null)
                                Text(
                                  'Other User ID: ${listing['other_user']['user_id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              if (listing['other_user']['user_id'] != null)
                                const SizedBox(height: 4.0),
                              if (listing['other_user']['user_name'] != null)
                                Text(
                                  'Other User Name: ${listing['other_user']['user_name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              if (listing['other_user']['user_name'] != null)
                                const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
