import 'package:flutter/material.dart';

import 'login.dart';
import '../util/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Center(
      child: Text('Dashboard'),
    ),
    AccountsScreen(),
    Center(
      child: Text('Users'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Dashboard'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (choice) async {
              if (choice == 'logout') {
                bool response = await performLogout();
                if (response) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 'logout',
                )
              ];
            },
          )
        ],
      ),
      body: Center(
        child: Text('YOLO'),
      ),
    );
  }
}
