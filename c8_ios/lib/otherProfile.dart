import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'secondmain.dart';

class OtherProfile extends StatelessWidget {
  const OtherProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Circle Eight'),
      ),
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: FractionalOffset.topCenter,
              child: ProfilePicture(),
            ),
            Align(
              alignment: FractionalOffset.topCenter,
              child: ProfileName(string: 'Lars Svensson'),
            ),
            Row(
              children: [
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: ProductProfile(string: 'images/shoes.jpg'),
                ),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: ProductProfile(string: 'images/hatt.jpeg'),
                ),
              ],
            )
          ],
        ),
      ),
      //bottomNavigationBar: toolbar(),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.18,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0,
      ),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          'images/man.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0.06,
        MediaQuery.of(context).size.width * 0,
      ),
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          Text(
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07),
            string,
          ),
          Text(
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              "50% (12)"),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.07,
            child: Image.asset(
              'images/like.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductProfile extends StatelessWidget {
  const ProductProfile({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.07,
        MediaQuery.of(context).size.width * 0.1,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.width * 0.02,
      ),
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.height * 0.17,
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
