/*i
mport 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class CurrentOffer extends StatefulWidget {
  final String bidId;

  CurrentOffer({required this.bidId});

  @override
  State<CurrentOffer> createState() => _CurrentOfferState();
}

class _CurrentOfferState extends State<CurrentOffer> {
  late Future<List<dynamic>> _futureOffer;
  Api _api = Api();

  @override
  void initState() {
    super.initState();
    _futureOffer = fetchOffer(widget.bidId);
  }

  Future<List<dynamic>> fetchOffer(String bidId) async {
    final response =
        await http.get(Uri.parse('${_api.getApiHost()}/offer/$bidId'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return jsonData.map((bid) {
        final bidId = bid['bid_maker']['offer_id'];
        return {
          'offerId': bid['id'],
          'offered_items': bid['offered_items'],
          'bidMaker': bid['bid_maker']['name'],
          'bidReceiver': bid['bid_receiver']['name'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load offer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Offer'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: _futureOffer,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bidId = snapshot.data!['bid_id'];
              final bidMaker = snapshot.data!['bid_maker'];
              final bidReceiver = snapshot.data!['bid_receiver'];
              print('bidmaker: $bidMaker');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Bid Maker'),
                          SizedBox(height: 8),
                          Text(
                              '${bidMaker['user_name']} (${bidMaker['user_location']})'),
                          SizedBox(height: 8),
                          Text(
                              '${bidMaker['user_num_likes']} likes | ${bidMaker['user_num_dislikes']} dislikes'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Bid Receiver'),
                          SizedBox(height: 8),
                          Text(
                              '${bidReceiver['user_name']} (${bidReceiver['user_location']})'),
                          SizedBox(height: 8),
                          Text(
                              '${bidReceiver['user_num_likes']} likes | ${bidReceiver['user_num_dislikes']} dislikes'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Listings'),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bidMaker['listings'].length +
                          bidReceiver['listings'].length,
                      itemBuilder: (context, index) {
                        final listing = index < bidMaker['listings'].length
                            ? bidMaker['listings'][index]
                            : bidReceiver['listings']
                                [index - bidMaker['listings'].length];
                        return ListTile(
                          title: Text(listing['listing_name']),
                          subtitle: Text(listing['listing_description']),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
*/
