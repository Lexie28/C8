import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  File? _image;

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
          'profile_picture_path': '$userId.png',
        }));

    if (response.statusCode == 200) {
      // registration successful, navigate to main page
      Navigator.pushReplacement(
        _formKey.currentContext!,
        MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
      );
    } else {
      print("registration failed!" + response.statusCode.toString());
    }
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        _image = imagePermanent;
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
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
                CustomButton(
                    title: 'Pick from Gallery',
                    icon: Icons.image_outlined,
                    onClick: () => getImage(ImageSource.gallery)),
                CustomButton(
                    title: 'Pick from Camera',
                    icon: Icons.camera,
                    onClick: () => getImage(ImageSource.camera))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomButton(
      {required String title,
      required IconData icon,
      required VoidCallback onClick}) {
    return Container(
      width: 280,
      child: ElevatedButton(
          onPressed: onClick,
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 20,
              ),
              Text(title),
            ],
          )),
    );
  }
}
