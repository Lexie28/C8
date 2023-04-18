import 'package:flutter/material.dart';

class AddListing extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //Någon variabel som håller bilden kanske

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: toolbar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add Listing'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      body: Column(
        children: [
          // Profile picture
          GestureDetector(
            onTap: () {
              // TODO: Implement change profile picture logic
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement camera logic
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                    //size: 120,
                  ),
                  iconSize: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
            ),
          ),

          //TODO lägg till alla varor man har som man kan scrolla ner på
        ],
      ),
    );
  }
}
