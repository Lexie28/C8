//import 'dart:io';
//import 'package:c8_ios/otherProduct.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'api.dart';
import 'main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userId});

  final String userId;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();

  String _userName = '';
  String _userLocation = '';
  String _userContact= '';

  //Någon variabel som håller bilden kanske
  Future<void> changeTitle() async {
    print('New product title: ${_nameController.text}');

    if (_formKey.currentState!.validate()) {
      //final url = Uri.parse('${_api.getApiHost()}/listing/:id');
      final url =
          Uri.parse('${_api.getApiHost()}/listing/${widget.userId}');   //TODO: ändra path NÄR DEN FINNS

      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': '${_nameController.text}',
        'description': '${_locationController.text}',
        'category': '${_contactController.text}',
        'image_path': null,
      };
      final jsonBody = json.encode(body);
      final response = await http.patch(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! Listing uppdated!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
        );
      }
      else if(response.statusCode == 404){
        print("Error 404");
      }
      else if(response.statusCode == 500){
        print("Error 500");
      }
       else {
        print('Failed to update listing');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture
              GestureDetector(
                onTap: () {
                  // TODO: Implement change profile picture logic
                },
                child: Container(
                  margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120.0),
                    child: Image.asset(
                      'images/woman.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      
              // TODO: knapp för ändra profil
              // Name field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'New Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userName = value;
                  },
                ),
              ),
      
              // Name field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'New Location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userLocation = value;
                  },
                ),
              ),


              /*
              DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Listing Category'),
                  value: _categories[0],
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _listingCategory = value.toString();
                    });
                  },
                ),
                */
                Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'New Contact info',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userContact = value;
                  },
                ),
              ),
              // Bio field
              // Save button
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    changeTitle();
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
