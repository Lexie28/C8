//import 'dart:io';
//import 'package:c8_ios/otherProduct.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'api.dart';
import 'main.dart';

class EditListing extends StatefulWidget {
  const EditListing({super.key, required this.itemId});

  final int itemId;

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();

  String _listingName = '';

  String _listingDescription = '';

  //Någon variabel som håller bilden kanske
  Future<void> changeTitle() async {
    print('New product title: ${_titleController.text}');

    if (_formKey.currentState!.validate()) {
      //final url = Uri.parse('${_api.getApiHost()}/listing/edit/:listing_id');
      final url =
          Uri.parse('${_api.getApiHost()}/listing/edit/${widget.itemId}');

      final headers = {'Content-Type': 'application/json'};
      final body = {
        'listing_name': '${_titleController.text}',
        'listing_description': '${_descController.text}',
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
      } else {
        print('NOOOO');
      }
    }
  }

  void changeDesc() {
    print('New product title: ${_descController.text}');
    //Ändra description i databasen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
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
                      'images/apple.jpg',
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
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'New Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _listingName = value;
                  },
                ),
              ),
      
              // Name field
              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'New Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _listingDescription = value;
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
                    // TODO: Implement save changes logic
                    changeTitle();
                    changeDesc();
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
