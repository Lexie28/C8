import 'package:flutter/material.dart';
import 'otherProfile.dart';

class CompletedOffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed offer'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.07,
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.2),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    // TODO:
                    builder: (BuildContext context) => OtherProfile(
                      userId: '1',
                    ),
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'images/man.jpg',
                  ),
                ),
              ),
            ),
            Text('You and Lars have agreed to trade!'),
            Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 132, 208, 127),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.headphones),
                    iconSize: MediaQuery.of(context).size.width * 0.12,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_upward),
                    iconSize: MediaQuery.of(context).size.width * 0.1,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apple),
                    iconSize: MediaQuery.of(context).size.width * 0.12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'Contact Lars!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('telephone: 1234556789'),
                Text('mail: lasse@lasse.lars'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
