import 'dart:io';

import 'package:c8_ios/profile.dart';
import 'package:flutter/material.dart';
import '../toolbar.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture
              GestureDetector(
                onTap: () {
                  // TODO: Implement change profile picture logic
                },
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implement camera logic
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.blue,
                      size: 120,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.0),
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16.0),
              // Name field
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Bio field
              TextField(
                controller: _contactController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Contact details',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Save button
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
