import 'dart:convert';
import 'package:c8_ios/yourProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'profile.dart';
import 'specificItem.dart';
import 'main.dart';

class AcceptedOffer extends StatefulWidget {
  final String makerId;
  final String recieverId;

  AcceptedOffer({required this.makerId, required this.recieverId});

  @override
  State<AcceptedOffer> createState() => _AcceptedOfferState();
}

class _AcceptedOfferState extends State<AcceptedOffer> {
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
    fetchUser(widget.makerId, widget.recieverId);
    super.initState();
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
        body: Column(
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                color: Color.fromARGB(255, 227, 235, 241),
                height: MediaQuery.of(context).size.width * 0.34,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "This offer is accepted! Please contact eachother to move forward with the trade.",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
              ),
            ),
            Text("Contact this user: " + bidReceiverName),
          ],
        ));
  }
}
