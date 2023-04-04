import 'package:c8_ios/addlisting.dart';
import 'package:c8_ios/homePage2.dart';
import 'package:c8_ios/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import '../main.dart';
import 'offers.dart';

class toolbar extends StatefulWidget {
  const toolbar({super.key});

  //void _onItemTapped(int index) {}

  @override
  State<StatefulWidget> createState() => _Toolbar();
}

class _Toolbar extends State<toolbar> {
  int _selectedIndex = 0;

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
          label: 'New listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cached),
          label: 'Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2),
          label: 'My profile',
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFA2BABF),
      currentIndex: _selectedIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage2(),
              ),
            );
            break;
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => AddListing(),
              ),
            );
            break;
          case 2:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Offers(),
              ),
            );
            break;
          case 3:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Profile(),
              ),
            );
            break;
        }
        setState(
          () {
            _selectedIndex = index;
          },
        );
      },
    );
  }
}
