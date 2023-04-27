import 'package:c8_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hometest.dart';
import 'api.dart';
import 'editprofile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CreateListingPage extends StatefulWidget {
  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String _userId = '';
  String _listingName = '';
  String _listingDescription = '';
  String _listingCategory = 'Other';
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

  Api _api = Api();

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('uid');


      //{ name, description, creation_date, image_path, category, owner_id
      
      final url = Uri.parse('${_api.getApiHost()}/listing');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': _listingName,
        'description': _listingDescription,
        'creation_date': null, //TODO! CREATION DATE
        'image_path': null, //TODO
        'category': _listingCategory,
        'owner_id': userId
      };
      final jsonBody = json.encode(body);
      final response = await http.post(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! New listing created!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
        );
      } else {
        print('NOOOO');
      }
    }
  }

/*
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://130.243.238.100:5000/listing/create');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'id': _userId,
        'name': _listingName,
        'description': _listingDescription,
        'category': _listingCategory,
      };
      final jsonBody = json.encode(body);
      final response = await http.post(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! New listing created!');
      } else {
        print('NOOOO');
      }
    }
  }
*/
/*
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://130.243.238.100:5000/listing/create');
      final response = await http.post(url, body: {
        'id': _userId,
        'name': _listingName,
        'description': _listingDescription,
        'category': _listingCategory,
      });
      if (response.statusCode == 200) {
        // Success
        print('Good! New listing created!');
      } else {
        // Error, handle it
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Listing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Listing Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a listing name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _listingName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Listing Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a listing description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _listingDescription = value;
                  },
                ),
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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Create Listing'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
