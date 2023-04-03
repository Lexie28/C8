import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../main.dart';

class toolbar extends StatelessWidget {
  const toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cached),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2),
          label: 'School',
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFA2BABF),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cached),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2),
          label: 'School',
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFA2BABF),
    );
  }
}