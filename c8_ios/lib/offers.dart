import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../toolbar.dart';
import 'settings.dart';

class Offers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: Color(0xFFA2BABF),
      ),
      bottomNavigationBar: toolbar(),
    );
  }
}
