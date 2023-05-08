import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'api.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

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

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  Api _api = Api();

  String? _name;
  String? _location;
  String? _phone;
  File? _image;
  bool imagePicked = false;

  void _submitForm() async {
    _formKey.currentState!.save();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final email = prefs.getString('email');

    final url = Uri.parse("${_api.getApiHost()}/user");
    final String? uploadedImageName;

    if (imagePicked) {
      uploadedImageName = await _upload(_image);
    } else {
      uploadedImageName = 'defaultProfilePicture.png';
    }

    if (_name!.isNotEmpty && _location!.isNotEmpty && _phone!.isNotEmpty) {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'id': userId,
            'location': _location,
            'name': _name,
            'phone_number': _phone,
            'profile_picture_path': uploadedImageName
          }));

      if (response.statusCode == 200) {
        // registration successful, navigate to main page
        Navigator.pushReplacement(
          _formKey.currentContext!,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
        );
      } else {
        print("registration failed!${response.statusCode}");
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

      imagePicked = true;
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final ext = p.extension(imagePath);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final image = File('${directory.path}/$userId$ext');

    return File(imagePath).copy(image.path);
  }

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
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: imagePicked
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            'https://circle8.s3.eu-north-1.amazonaws.com/defaultProfilePicture.png',
                          ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value!;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.1,
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: customButton(
                    title: 'Pick from Gallery',
                    icon: Icons.image_outlined,
                    onClick: () => getImage(ImageSource.gallery),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: customButton(
                    title: 'Pick from Camera',
                    icon: Icons.camera,
                    onClick: () => getImage(ImageSource.camera),
                  ),
                ),
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

Widget customButton(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Text(title),
        ],
      ));
}
