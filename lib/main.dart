import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'util/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool response = await checkLogin();
  runApp(MyApp(isLoggedIn: response));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key key, @required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verve Admin',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage() : LoginPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage()
      },
    );
  }
}
