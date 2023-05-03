import 'package:c8_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid_util.dart';
import 'dart:convert';
import 'hometest.dart';
import 'api.dart';
import 'editprofile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'createprofile.dart';

import 'package:path/path.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:uuid/uuid.dart';





SimpleS3 _simpleS3 = SimpleS3();
Future<String?> _upload(File? fileToUpload) async {
  String? result;
  if (result == null) {
    try {
      result = await _simpleS3.uploadFile(
        fileToUpload!,
        'circle8',
        'eu-north-1:c6a2d96e-f475-42b0-a949-f8c5f98a4b9b',
        AWSRegions.euNorth1,
        debugLog: true,
        s3FolderPath: "",
        accessControl: S3AccessControl.publicReadWrite,
      );
      result = basename(fileToUpload.path);
    } catch (e) {
      print(e);
    }
  }
  return result;
}


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

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        _image = imagePermanent;
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  
  Future<File> saveFilePermanently(String imagePath) async {
    var uuid = Uuid();
    var uuidCrypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});  //Brag about this

    final directory = await getApplicationDocumentsDirectory();
    final ext = extension(imagePath);
    final image = File('${directory.path}/$uuidCrypto$ext');

    return File(imagePath).copy(image.path);
  }
  Future<void> _submitForm() async {
     _formKey.currentState!.save();
      final uploadedImageName = await _upload(_image);

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('uid');
      //{ name, description, creation_date, image_path, category, owner_id
      final url = Uri.parse('${_api.getApiHost()}/listing');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': _listingName,
        'description': _listingDescription,
        'creation_date': null, //TODO! CREATION DATE
        'image_path': uploadedImageName, //TODO
        'category': _listingCategory,
        'owner_id': userId
      };
      final jsonBody = json.encode(body);

      final response = await http.post(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! New listing created!');
        Navigator.pushReplacement(
        _formKey.currentContext!,
        MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
      );
      } else {
        print('NOOOO');
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
                CustomButton(
                    title: 'Pick from Gallery',
                    icon: Icons.image_outlined,
                    onClick: () => getImage(ImageSource.gallery)),
                CustomButton(
                    title: 'Pick from Camera',
                    icon: Icons.camera,
                    onClick: () => getImage(ImageSource.camera)),
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
