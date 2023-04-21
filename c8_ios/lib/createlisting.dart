import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hometest.dart';
import 'api.dart';
import 'editprofile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateListingPage extends StatefulWidget {
  @override
  _CreateListingPageState createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String _userId = '';
  String _listingName = '';
  String _listingDescription = '';
  String _listingCategory = '';
  List<String> _categories = ['Category 1', 'Category 2', 'Category 3'];

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
      final url = Uri.parse('${_api.getApiHost()}/listing/create');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'user_id': _userId,
        'listing_name': _listingName,
        'listing_description': _listingDescription,
        'listing_category': _listingCategory,
        // 'listing_photo': _image,
      };
      final jsonBody = json.encode(body);
      final response = await http.post(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! New listing created!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage3()),
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
        'user_id': _userId,
        'listing_name': _listingName,
        'listing_description': _listingDescription,
        'listing_category': _listingCategory,
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
        'user_id': _userId,
        'listing_name': _listingName,
        'listing_description': _listingDescription,
        'listing_category': _listingCategory,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'User ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  _userId = value;
                },
              ),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Listing Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a listing category';
                  }
                  return null;
                },
                onChanged: (value) {
                  _listingCategory = value;
                },
              ),
              SizedBox(height: 16.0),
              _image != null
                  ? Image.file(_image!,
                      width: 250, height: 250, fit: BoxFit.cover)
                  : SizedBox(),
              CustomButton(
                  title: 'Add photo from gallery',
                  icon: Icons.camera,
                  onClick: getImage),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


