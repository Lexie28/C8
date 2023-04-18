import 'dart:io';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //Någon variabel som håller bilden kanske

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
                  child: Image.asset(
                    'images/woman.jpg',
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
                MediaQuery.of(context).size.width * 0.01,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save changes logic
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
