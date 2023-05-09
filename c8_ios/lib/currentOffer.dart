import 'dart:convert';
import 'package:c8_ios/yourProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'profile.dart';
import 'specificitem.dart';

class CurrentOffer extends StatefulWidget {
  final String bidId;

  CurrentOffer({required this.bidId});

  @override
  State<CurrentOffer> createState() => _CurrentOfferState();
}

class _CurrentOfferState extends State<CurrentOffer> {
  List<dynamic> _futureOffer = [];
  Api _api = Api();
  String myID = '';
  String bidMakerName = '';
  String bidReceiverName = '';
  int makerLikes = 0;
  int makerDislikes = 0;
  int recLikes = 0;
  int recDislikes = 0;

  @override
  void initState() {
    super.initState();
    fetchOffer(widget.bidId);
    print('futureoffer: $_futureOffer');
  }

  Future<void> fetchOffer(String bidId) async {
    final response =
        await http.get(Uri.parse('${_api.getApiHost()}/offer/$bidId'));
    print(bidId);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      setState(() {
        _futureOffer = jsonData.map((bid) {
          final bidId = bid['user_making_offer'];
          final bidRec = bid['user_receiving_offer'];
          fetchUser(bidId, bidRec);

          return {
            'offerId': bid['id'],
            'bidMakerId': bid['user_making_offer'],
            'bidReceiverId': bid['user_receiving_offer'],
            'offered_items': bid['offered_items'],
            'wanted_items': bid['wanted_items'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load offer');
    }
  }

  Future<void> fetchUser(String bidMaker, String bidRec) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$bidMaker'));

    final response2 = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$bidRec'));

    if (response.statusCode == 200) {
      User maker = User.fromJson(jsonDecode(response.body));
      User rec = User.fromJson(jsonDecode(response2.body));
      setState(() {
        bidMakerName = maker.userName;
        bidReceiverName = rec.userName;
        makerLikes = maker.likes;
        makerDislikes = maker.dislikes;
        recLikes = rec.likes;
        recDislikes = rec.dislikes;
        myID = userId!;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Current Offer'),
      ),
      body: ListView.builder(
          itemCount: _futureOffer.length,
          itemBuilder: (context, index) {
            final offerId = _futureOffer[index]['offerId'];
            print(offerId);
            final bidMakerId = _futureOffer[index]['bidMakerId'];
            final bidReceiverId = _futureOffer[index]['bidReceiverId'];
            final offered_items = _futureOffer[index]['offered_items'];
            final wanted_items = _futureOffer[index]['wanted_items'];

            return myID == bidMakerId
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Bid Maker:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                bidMakerName,
                                style: style,
                              ),
                              Text(
                                  '$makerLikes likes | $makerDislikes dislikes'),
                              SizedBox(height: 8),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Bid Receiver:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                bidReceiverName,
                                style: style,
                              ),
                              Text('$recLikes likes | $recDislikes dislikes'),
                              SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Offering:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...offered_items.map(
                            (offered_items) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                offered_items.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            YourProduct(itemIndex: 0),
                                      ));
                                    },
                                    child: Text(
                                      offered_items[index]['name'].toString(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Want:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...wanted_items.map(
                            (wanted_items) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                wanted_items.length,
                                (index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListingDetailPage(
                                                  listingId: wanted_items[index]
                                                          ['listing_id']
                                                      .toString()),
                                        ));
                                      },
                                      child: Text(
                                        wanted_items[index]['name'].toString(),
                                      ));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : Text("you are not bidmaker");
          }),
    );
  }
}
