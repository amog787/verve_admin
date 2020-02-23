import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/api.dart';

class AccountForm extends StatefulWidget {
  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _usnController = TextEditingController();
  final _amountController = TextEditingController();
  String _method = 'Cash';

  bool _isValidForm = false;

  @override
  void initState() {
    super.initState();
    _usnController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usnController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValidForm =
          _usnController.text.isNotEmpty && _amountController.text.isNotEmpty;
    });
  }

  void _handleMethodChange(String method) {
    setState(() {
      _method = method;
    });
  }

  void _handleSubmit() async {
    Map<String, dynamic> data = {
      'user': _usnController.text,
      'amount': _amountController.text,
      'method': _method
    };
    var response = await performPost('accounts', data);
    Navigator.of(context).pop();
    if (response['success']) {
      _showDialog('Account has been settled successfully.');
    } else {
      _showDialog(response['message'], error: true);
    }
  }

  void _showDialog(String message, {bool error = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            error ? 'ERROR' : 'SUCCESS',
            style: error ? TextStyle(color: Colors.red) : null,
          ),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter the USN',
                  ),
                  controller: _usnController,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Enter the amount'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: _amountController,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildGestureDetector('Cash'),
              _buildGestureDetector('Google Pay'),
              _buildGestureDetector('PayTM'),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Settle',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.blue,
                  onPressed: _isValidForm ? _handleSubmit : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  GestureDetector _buildGestureDetector(String value) {
    return GestureDetector(
      onTap: () => _handleMethodChange(value),
      child: Row(
        children: <Widget>[
          Radio<String>(
            value: value,
            groupValue: _method,
            onChanged: (value) {},
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
