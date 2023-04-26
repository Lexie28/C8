import 'package:c8_ios/profile.dart';
import 'package:c8_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
//import 'dart:io';

class CreateProfile extends StatefulWidget {
  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //File? _image;
  String _userId = '';
  String _userName = '';
  String _userLocation = '';
  //String _userDescription = '';
  String _contactDetails = '';
  String _userPhoneNumber = '';
  Api _api = Api();

  Future<void> _submitUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('${_api.getApiHost()}/user');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'id': _userId, //Ska vara google id?
        'name': _userName,
        'profile_picture_path':null,
        'phone_number': _userPhoneNumber,        
        'email': _contactDetails,
        'location': _userLocation
        // 'image_path': _image,
      };
      final jsonBody = json.encode(body);
      final response = await http.post(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! New user created!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
        );
      } else {
        print('NOOOO');
      }
    }
  }

  //Någon variabel som håller bilden kanske
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement camera logic
                  },
                  icon: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: IconButton(
                      onPressed: () {
                        //TODO implement adding a profilepic
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                      ),
                      iconSize: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                ),
              ),
              // Name field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userName = value;
                  },
                ),
              ),
              // Location field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userLocation = value;
                  },
                ),
              ),
              // Bio field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _contactController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Contact details',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _contactDetails = value;
                  },
                ),
              ),
              // Save button
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.1,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement save changes logic
                    _submitUser();
                  },
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
