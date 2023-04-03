import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../toolbar.dart';

class AddListing extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //Någon variabel som håller bilden kanske

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: toolbar(),
      appBar: AppBar(
        title: Text('Add Listing'),
        backgroundColor: Color(0xFFA2BABF),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

                //TODO lägg till alla varor man har som man kan scrolla ner på
            ],
          ), 
      ),   
    );
  }
}
