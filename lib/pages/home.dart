import 'package:flutter/material.dart';

import 'login.dart';
import '../screens/accounts.dart';
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
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.attach_money),
        tooltip: 'Settle',
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Accounts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Users'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
