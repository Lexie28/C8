import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'authentication.dart';
import 'main.dart';
import 'color.dart' as colo;

class Settings extends StatelessWidget {
  Future<void> _deleteUserId(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    final api = Api();
    final url = '${api.getApiHost()}/user/$userId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete UserId'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: colo.primary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Settings(),
                  ),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: SettingsOption(
                text: 'About us',
                onPressed: () {},
              )),
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: SettingsOption(
              text: 'Log out',
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Log out'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Log out'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (confirm) {
                  await Authentication.signOut(context: context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => FirstPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: SettingsOption(
              text: 'Delete account',
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete account'),
                      content: Text(
                          'Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            _deleteUserId(context);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (confirm) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => C8(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SettingsOption({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final color = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final accentColor = colo.primary;
    final textColor = isDarkMode ? accentColor : Colors.black;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: accentColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
