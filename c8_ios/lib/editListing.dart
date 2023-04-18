//import 'dart:io';
//import 'package:c8_ios/otherProduct.dart';
import 'package:flutter/material.dart';

class EditListing extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descController = TextEditingController();
  //Någon variabel som håller bilden kanske

  void changeTitle() {
    print('New product title: ${_titleController.text}');
    //Ändra namnet i databasen
  }

  void changeDesc() {
    print('New product title: ${_descController.text}');
    //Ändra description i databasen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
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
                    'images/apple.jpg',
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
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'New Title',
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
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'New Description',
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
                  // TODO: Implement save changes logic
                  changeTitle();
                  changeDesc();
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
