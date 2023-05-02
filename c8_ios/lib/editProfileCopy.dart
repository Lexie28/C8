/*
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'api.dart';
import 'main.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);
  //Någon variabel som håller bilden kanske

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();


  String _userName = "";
  String _userLocation = "";
  String _userContact = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: SingleChildScrollView(
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
                  child: _image != null
                      ? Image.file(_image!,
                          width: 250, height: 250, fit: BoxFit.cover)
                      : Image.asset(
                          'images/woman.jpg',
                          fit: BoxFit.cover,
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
                    _userContact = value;
                  },
              ),
            ),
            // Save button
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.01,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save changes logic
                },
                child: Text('Save Changes'),
              ),
            ),
            CustomButton(
                title: 'Pick from Gallery',
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery)),
            CustomButton(
                title: 'Pick from Camera',
                icon: Icons.camera,
                onClick: () => getImage(ImageSource.camera)),
          ],
        ),
      ),
    );
  }
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

*/