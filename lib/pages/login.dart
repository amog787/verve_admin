import 'package:flutter/material.dart';

import 'home.dart';
import '../util/api.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: 80.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Welcome back.',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 120.0,
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usnController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValidForm = false;

  @override
  void initState() {
    super.initState();
    _usnController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _usnController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isValidForm =
          _usnController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  void _onPressed() async {
    String usn = _usnController.text;
    String password = _passwordController.text;
    var response = await performLogin(usn, password);
    if (!response['success']) {
      final snackbar = SnackBar(
        content: Text(response['message']),
        action: SnackBarAction(
          label: 'OKAY',
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _usnController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 12.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.vpn_key),
          ),
          obscureText: true,
        ),
        ButtonBar(
          children: <Widget>[
            RaisedButton(
              color: Colors.blue,
              child: Text('NEXT'),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              onPressed: _isValidForm ? _onPressed : null,
            )
          ],
        )
      ],
    );
  }
}
