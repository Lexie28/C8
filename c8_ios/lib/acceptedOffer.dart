import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'profile.dart';
import 'main.dart';

class AcceptedOffer extends StatefulWidget {
  final String makerId;
  final String recieverId;
  final String offerId;

  AcceptedOffer(
      {required this.makerId, required this.recieverId, required this.offerId});

  @override
  State<AcceptedOffer> createState() => _AcceptedOfferState();
}

class _AcceptedOfferState extends State<AcceptedOffer> {
  List<dynamic> _futureOffer = [];
  Api _api = Api();
  String myID = '';
  String bidMakerName = '';
  String bidReceiverName = '';
  String bidMakerNumber = '';
  String receiverNumber = '';
  String bidMakerMail = '';
  String bidReceiverMail = '';

  void completeOffer(String offerId) async {
    // TODO vi deletar nu när vi completear
    final url = '${_api.getApiHost()}/offer/$offerId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to complete (delete) offer'),
        ),
      );
    }
  }

  @override
  void initState() {
    fetchUser(widget.makerId, widget.recieverId);
    super.initState();
  }

  Future<void> fetchUser(String bidMaker, String bidRec) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    myID = userId!;

    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$bidMaker'));

    final response2 = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$bidRec'));

    if (response.statusCode == 200) {
      User maker = User.fromJson(jsonDecode(response.body));
      User rec = User.fromJson(jsonDecode(response2.body));
      print(rec.userName);
      print(maker.userName);
      setState(() {
        bidMakerName = maker.userName;
        bidReceiverName = rec.userName;
        bidMakerNumber = maker.phoneNumber;
        receiverNumber = rec.phoneNumber;

        bidMakerMail = maker.email;
        bidReceiverMail = rec.email;
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
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width*0.7,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Image.asset(
                    'images/highfive.png',
                    fit: BoxFit.cover,
                  ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Color.fromARGB(255, 227, 235, 241),
                    height: MediaQuery.of(context).size.width * 0.54,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "This offer is accepted! Please contact eachother to move forward with the trade. When offer is complete, please press the 'Offer completed' button",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            myID == widget.recieverId
                ? SizedBox(
                    child: Column(
                      children: [
                        Text("Contact this user: $bidMakerName"),
                        Text("Phone number: $bidMakerNumber"),
                        Text("Email: $bidMakerMail"),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.05),
                    child: Column(children: [
                      Text(
                        "$bidReceiverName",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.08),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25 ),
                        child: Row(
                          children: [
                            Text(
                              "Phone number: ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text("$receiverNumber"),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25 ),
                        child: Row(
                          children: [
                            Text(
                              "Email: ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text("$bidReceiverMail")
                          ],
                        ),
                      ),
                    ]),
                  ),
            Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                    "Please contact eachother in 30 days or save the information!")),
          ],
        ));
  }
}
