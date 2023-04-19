import 'package:c8_ios/profile.dart';
import 'package:flutter/material.dart';
//import 'dart:io';

class CreateProfile extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //Någon variabel som håller bilden kanske

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: IconButton(
                onPressed: () {
                  // TODO: Implement camera logic
                },
                icon: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: IconButton(
                    onPressed: () {
                      //TODO implement adding a profilepic
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.blue,
                    ),
                    iconSize: MediaQuery.of(context).size.width * 0.3,
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
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
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
              ),
            ),
            // Save button
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.1,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save changes logic
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Profile(),
                    ),
                  );
                },
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
