import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/api.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: performGet('accounts'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['success']) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              itemBuilder: (context, index) {
                var account = snapshot.data['data'][index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10.0),
                    leading: Icon(
                      Icons.person_outline,
                      size: 48.0,
                    ),
                    title: Text(account['name']),
                    subtitle: Text(account['phone']),
                    trailing: Text(
                      '\u20b9 ' + account['total'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () async {
                      String urlString = 'tel:' + account['phone'];
                      if (await canLaunch(urlString)) {
                        await launch(urlString);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Unable to open the dailer at the moment.',
                          ),
                          action: SnackBarAction(
                            label: 'OKAY',
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ));
                      }
                    },
                  ),
                );
              },
              itemCount: snapshot.data['data'].length,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.tag_faces),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(snapshot.data['message']),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
