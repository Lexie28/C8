import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'toolbar.dart';
import 'otherProduct.dart';
import 'categories.dart';
import 'otherProfile.dart';
//import 'package:english_words/english_words.dart';
//import 'dart:async';
// for access to jsonEncode to encode the data

void main() async {
  runApp(const C8iOS());
}

class C8iOS extends StatelessWidget {
  const C8iOS({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Circle Eight',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 112, 167, 158)),
        ),
        home: HomePage(),
      ),
    );
  }
}

//  defines the data the app needs to function
class MyAppState extends ChangeNotifier {}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _message;

  // this function will send message to our backend
  void sendMessage(msg) {
    IOWebSocketChannel? channel;

    // connection might fail
    try {
      channel = IOWebSocketChannel.connect('ws://localhost:3000');
    } catch (e) {
      print("Error on connecting to websocket: " + e.toString());
    }

    channel?.sink.add(msg);

    channel?.stream.listen((event) {
      if (event!.isNotEmpty) {
        print(event);
        channel!.sink.close();
      }
    });

    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(string: 'Circle Eight'),
            SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const OtherProduct(),
                  ),
                );
              },
              child: SmallCard(string: '9. Annan produkt'),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Categories(),
                  ),
                );
              },
              child: SmallCard(string: 'Categories'),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const otherProfile(),
                  ),
                );
              },
              child: SmallCard(string: '9.5 Other Profile'),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////BIG CARD////////////////////////////////////////
class BigCard extends StatelessWidget {
  const BigCard({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          string,
          style: style,
        ),
      ),
    );
  }
}

////////////////////////////SMALL CARD//////////////////////////////
class SmallCard extends StatelessWidget {
  SmallCard({required this.string});

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.inversePrimary,
      elevation: 5,
      child: SizedBox(
        height: 80,
        width: 270,
        child: Center(
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}

////////////////////////OTHER PROFILE/////////////////////////////////

