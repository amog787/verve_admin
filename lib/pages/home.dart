import 'package:flutter/material.dart';

import 'login.dart';
import '../util/api.dart';

class HomePage extends StatelessWidget {
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
