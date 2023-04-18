import 'package:c8_ios/categories.dart';
import 'package:c8_ios/offer.dart';
import 'package:flutter/material.dart';
import 'completedOffer.dart';

class Offers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: Color(0xFFA2BABF),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ColorExpl(
                string: 'your bids', color: Color.fromARGB(255, 112, 139, 221)),
            ColorExpl(
                string: 'recieved bids',
                color: Color.fromARGB(255, 216, 202, 93)),
            ColorExpl(
                string: 'completed bids',
                color: Color.fromARGB(255, 119, 179, 108)),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(' Yours', style: style),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Theirs',
                      textAlign: TextAlign.start,
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Offer(),
                    ),
                  );
                },
                child: Category(string: 'Offer'),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CompletedOffer(),
                    ),
                  );
                },
                child: Category(string: 'Completed offer'),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ColorExpl extends StatelessWidget {
  ColorExpl({required this.string, required this.color});

  final String string;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        string,
        style: style,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.021,
        width: MediaQuery.of(context).size.height * 0.075,
        child: Card(
          color: color,
          elevation: 3,
        ),
      ),
    ]);
  }
}

class Bid extends StatelessWidget {
  Bid({required this.state});

  final int state;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
