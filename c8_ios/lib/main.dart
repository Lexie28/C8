import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:c8_ios/login.dart';
import 'package:c8_ios/createprofile.dart';
import 'package:c8_ios/editprofile.dart';
import 'package:c8_ios/addlisting.dart';
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
            Expanded(
              child: Center(
                child: TextField(
                  onChanged: (e) => _message = e,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: TextButton(
                  child: const Text("Send"),
                  onPressed: () {
                    if (_message!.isNotEmpty) {
                      sendMessage(_message);
                    }
                  },
                ),
              ),
            ),
            BigCard(string: 'Circle Eight'),
            SizedBox(height: 80),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>  AddListing(),
                    ),
                  );
                },
                child: SmallCard(string: 'Log In')),
            SizedBox(height: 15),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const CreateAccount(),
                    ),
                  );
                },
                child: SmallCard(string: 'Create Account')),
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

class CreateAccount extends StatelessWidget {
  // TODO Skapa konto med Google!!

  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 200,
            ),
            BigCard(string: 'Placeholder for Google login')
          ]),
        ));
  }
}
