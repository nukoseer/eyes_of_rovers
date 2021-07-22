import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:eyes_of_rovers/authentication.dart';

class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            "User Account Page",
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.chevron_left,
            ),
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _buildUserAccountPage(),
        ),
      ),
    );
  }

  Widget _buildUserAccountPage() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 48.0),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        UserInformation.bigProfilePictureUrl,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${UserInformation.name}",
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${UserInformation.email}",
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 64.0),
                CupertinoButton(
                  onPressed: () {
                    Authenticate.signOut();
                  },
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

