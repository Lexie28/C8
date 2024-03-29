import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
import 'profile.dart';
import 'createprofile.dart' as cp;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.userId});

  final String userId;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Api _api = Api();

  String profilePicturePath = 'loading.png';

  @override
  void initState() {
    super.initState();
    fetchPP(widget.userId);
  }

  Future<void> changeTitle() async {
    print('New product title: ${_nameController.text}');

    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          '${_api.getApiHost()}/user/${widget.userId}'); //TODO: ändra path NÄR DEN FINNS

      final headers = {'Content-Type': 'application/json'};
      final body = {
        'name': _nameController.text,
        'location': _locationController.text,
        'phone_number': _contactController.text,
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

  Future<void> fetchPP(String userId) async {
    final response = await http
        .get(Uri.parse('${_api.getApiHost()}/pages/profilepage/$userId'));

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));

      setState(() {
        profilePicturePath = user.profilePicturePath;
      });
    } else {
      throw Exception('Failed to load album');
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
                  // TODO: Implement change profile picture logic
                },
                child: Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120.0),
                    child: Image.network(
                      'https://circle8.s3.eu-north-1.amazonaws.com/$profilePicturePath',
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Edit Name',
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
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Edit Location',
                    border: OutlineInputBorder(),
                  ),
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
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Edit phone number',
                    border: OutlineInputBorder(),
                  ),
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
