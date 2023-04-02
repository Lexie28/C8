import 'package:c8_ios/otherProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../main.dart';
import '../toolbar.dart';

class OtherProduct extends StatefulWidget {
  // TODO Logga in med Google!!

  const OtherProduct({super.key});

  @override
  State<OtherProduct> createState() => _OtherProductState();
}

class _OtherProductState extends State<OtherProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Listing'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: productListing(string: 'images/shoes.jpg'),
                ),
                Align(
                    alignment: FractionalOffset.topRight,
                    child: listingProfile(string: 'Lars')),
                //CardProduct(string: 'Hej'),
              ],
            ),
            Align(
              alignment: FractionalOffset.topLeft,
              child: ProductName(string: 'Shoes'),
            ),
            Align(
              alignment: FractionalOffset.topLeft,
              child: ProductInfo(
                  string:
                      'Nice pair of shoes. Bought 2 months ago and only worn twice.'),
            ),
            Align(
              alignment: FractionalOffset.topLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(35, 30, 10, 0),
                child: Text(
                  'Number of bids',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: numBids(string: '5'),
                ),
                Align(
                  alignment: FractionalOffset.center,
                  child: BidButton(),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: toolbar(),
    );
  }
}

class ProductName extends StatelessWidget {
  const ProductName({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(35, 0, 10, 0),
      child: Text(
        style: TextStyle(fontSize: 30),
        string,
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return FittedBox(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Card(
          margin: const EdgeInsets.fromLTRB(30, 0, 10, 0),
          color: theme.colorScheme.onSecondary,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              string,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class numBids extends StatefulWidget {
  const numBids({required this.string,
  });

  final String string;

  @override
  State<numBids> createState() => _numBidsState();
}

class _numBidsState extends State<numBids> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.32,
      child: Card(
        margin: const EdgeInsets.fromLTRB(30, 0, 10, 0),
        color: theme.colorScheme.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(23, 15, 15, 15),
          child: Text(
            '5', //TODO: Kan inte ges som argument. Förmodligen pga stateful widget.
            style: style,
          ),
        ),
      ),
    );
  }
}

class BidButton extends StatefulWidget {
  const BidButton({super.key});

  @override
  State<BidButton> createState() => _BidButtonState();
}

class _BidButtonState extends State<BidButton> {
  String buttonName = "Bid";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.height * 0.17,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            buttonName = "Bidded";
          });
        },
        child: Text(buttonName),
      ),
    );
  }
}

class productListing extends StatelessWidget {
  const productListing({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 60, 30, 20),
      //margin: const EdgeInsets.symmetric(
      //    vertical: 60, horizontal: 30),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        border: Border.all(width: 2.2, color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 113, 113, 113),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.5, 1.5), // shadow direction: bottom right
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.0),
        child: Image.asset(
          string,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class listingProfile extends StatelessWidget {             //TODO: Fetch data från databas
  const listingProfile({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 65, 10, 0),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset(
              'images/man.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const otherProfile(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              children: [
                Text(
                  style: TextStyle(fontSize: 20),
                  string,
                ),
                Text("50% (12)"),       //TODO
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.07,
                  child: Image.asset(
                    'images/like.png',              //TODO
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
