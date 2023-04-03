import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../main.dart';
import '../toolbar.dart';

class otherProfile extends StatelessWidget {
  const otherProfile({super.key});

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
              child: profilePicture(),
            ),
            Align(
              alignment: FractionalOffset.topCenter,
              child: profileName(string: 'Lars Svensson'),
            ),
            Row(
              children: [
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: productProfile(string: 'images/shoes.jpg'),
                ),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: productProfile(string: 'images/hatt.jpeg'),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: toolbar(),
    );
  }
}

class profilePicture extends StatelessWidget {
  const profilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
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

class profileName extends StatelessWidget {
  const profileName({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          Text(
            style: TextStyle(fontSize: 25),
            string,
          ),
          Text(style: TextStyle(fontSize: 18), "50% (12)"),
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

class productProfile extends StatelessWidget {
  const productProfile({required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 60, 10, 20),
      //margin: const EdgeInsets.symmetric(
      //    vertical: 60, horizontal: 30),
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.height * 0.17 ,
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
