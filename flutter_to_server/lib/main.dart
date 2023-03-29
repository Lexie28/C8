import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String? _message;

  // This function will send the message to our backend.
  void sendMessage(msg) {
      IOWebSocketChannel? channel;
  // We use a try - catch statement, because the connection might fail.
  try {
    // Connect to our backend.
    channel = IOWebSocketChannel.connect('ws://localhost:5000');
  } catch (e) {
    // If there is any error that might be because you need to use another connection.
    print("Error on connecting to websocket: " + e.toString());
  }
  // Send message to backend
  channel?.sink.add(msg);

  // Listen for any message from backend
  channel?.stream.listen((event) {
    // Just making sure it is not empty
    if (event!.isNotEmpty) {
      print(event);
      // Now only close the connection and we are done here!
      channel!.sink.close();
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
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
                    // Check if the message isn't empty.
                    if (_message!.isNotEmpty) {
                      sendMessage(_message);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}