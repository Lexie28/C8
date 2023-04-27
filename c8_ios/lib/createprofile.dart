import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  Api _api = Api();

  String _name = "";
  String _location = "";
  String _phone = "";

  void _submitForm() async {
    _formKey.currentState!.save();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final email = prefs.getString('email');

    final url = Uri.parse("${_api.getApiHost()}/user/registration");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'id': userId,
          'location': _location,
          'name': _name,
          'phone_number': _phone,
          'profile_picture_path': null,
        }));

    if (response.statusCode == 200) {
      // registration successful, navigate to main page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()));
    } else {
      print("registration failed!");
    }
  }

  //Någon variabel som håller bilden kanske
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Create Profile"),
    ),
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter your name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter your location";
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Create Profile"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
