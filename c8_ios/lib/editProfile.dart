import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_s3/simple_s3.dart';
import 'api.dart';
import 'main.dart';
import 'profile.dart';
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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userId});

  final String userId;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();

  String profilePicturePath = 'loading.png';

  @override
  void initState() {
    super.initState();
    fetchPP(widget.userId);
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
    final userId = widget.userId;
    final image = File('${directory.path}/$userId$ext');

    return File(imagePath).copy(image.path);
  }

  File? _image;
  bool imagePicked = false;

  Future<void> changeTitle() async {
    print('New product title: ${_nameController.text}');
    final String? uploadedImageName;

    if (imagePicked) {
      uploadedImageName = await _upload(_image);
    } else {
      uploadedImageName = profilePicturePath;
    }
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('${_api.getApiHost()}/user/${widget.userId}');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': _nameController.text,
        'location': _locationController.text,
        'phone_number': _contactController.text,
        'image_path': uploadedImageName
      };
      final jsonBody = json.encode(body);
      final response = await http.patch(url, headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        // Success
        print('Good! Profile updated!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationbar()),
        );
      } else if (response.statusCode == 404) {
        print("Error 404");
      } else if (response.statusCode == 500) {
        print("Error 500");
      } else {
        print('Failed to update profile');
      }
    }
  }

  Future<void> fetchPP(String userId) async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$userId'));

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));

      setState(() {
        profilePicturePath = user.profilePicturePath;
        _nameController.text = user.userName;
        _locationController.text = user.location;
        _contactController.text = user.phoneNumber;
      });
    } else {
      throw Exception('Failed to load profile picture');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
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
                        : Image.network(
                            'https://circle8.s3.eu-north-1.amazonaws.com/$profilePicturePath',
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
                    labelText: 'New Name',
                    border: OutlineInputBorder(),
                  ),
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
                    labelText: 'New Location',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.01,
                ),
                child: TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

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
