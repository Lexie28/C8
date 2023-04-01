import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddListing extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //Någon variabel som håller bilden kanske

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                    bottomNavigationBar: Container( 
                color: Colors.blue,
                child: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.recycling),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              ),
      appBar: AppBar(
        title: Text('Add Listing'),
        backgroundColor: Colors.blue,

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
              
              SizedBox(height: 16.0),
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Bio field
              TextField(
                controller: _contactController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Product description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // Save button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement save changes logic
                },
                child: Text('Save Listing'),
              ),
            ],
          ), 
      ),   
    );
  }
}
