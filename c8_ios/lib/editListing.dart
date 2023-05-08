import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'api.dart';
import 'main.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

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
      result = p.basename(fileToUpload.path);
    } catch (e) {
      print(e);
    }
  }
  return result;
}

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

  File? _image;
  bool imagePicked = false;

  Future<void> _submitForm() async {
    _formKey.currentState!.save();
    final String? uploadedImageName;

    if (imagePicked) {
      uploadedImageName = await _upload(_image);
    } else {
      uploadedImageName = 'noImage.jpg';
    }
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('${_api.getApiHost()}/listing/${widget.itemId}');

      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': _titleController.text,
        'description': _descController.text,
        'category': _catController.text,
        'image_path': uploadedImageName,
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
      } else if (response.statusCode == 404) {
        print("Error 404");
      } else if (response.statusCode == 500) {
        print("Error 500");
      } else {
        print('Failed to update listing');
      }
    }
  }

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
    var uuidCrypto =
        uuid.v4(options: {'rng': UuidUtil.cryptoRNG}); //Brag about this

    final directory = await getApplicationDocumentsDirectory();
    final ext = p.extension(imagePath);
    final image = File('${directory.path}/$uuidCrypto$ext');

    imagePicked = true;

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
        backgroundColor: Color.fromARGB(255, 142, 219, 250),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120.0),
                    child: imagePicked
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/noImage.jpg',
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
                ),
              ),

              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Listing Category'),
                  value: _categories[0],
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {});
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
                    _submitForm();
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
