//import 'dart:io';
//import 'package:c8_ios/otherProduct.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'api.dart';
import 'main.dart';

class EditListing extends StatefulWidget {
  const EditListing({super.key, required this.itemId});

  final String itemId;

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _catController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();

  String _listingName = '';
  String _listingDescription = '';
  String _listingCategory = '';
  //String _listingCategory = 'Other';
  List<String> _categories = [
    'Other',
    'Clothing',
    'Books',
    'Beauty',
    'Accessories',
    'Collectables',
    'Furniture',
    'Electronics',
    'Houseware',
    'Sports'
  ];

  //Någon variabel som håller bilden kanske
  Future<void> changeTitle() async {
    print('New product title: ${_titleController.text}');

    if (_formKey.currentState!.validate()) {
      //final url = Uri.parse('${_api.getApiHost()}/listing/:id');
      final url = Uri.parse('${_api.getApiHost()}/listing/${widget.itemId}');

      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': '${_titleController.text}',
        'description': '${_descController.text}',
        'category': '${_catController.text}',
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
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
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
                  controller: _catController,
                  decoration: InputDecoration(
                    labelText: 'New Category',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _listingCategory = value;
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
