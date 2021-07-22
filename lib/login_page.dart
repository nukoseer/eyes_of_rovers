import 'package:eyes_of_rovers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _buildLoginPage(),
        ),
      ),
    );
  }

  Widget _buildLoginPage() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 75.0),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/rover.png"),
                  ),
                ),
                SizedBox(height: 64.0),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Eyes of Rovers",
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
                  ),
                ),
                SizedBox(
                  height: 96,
                ),
                Container(
                  height: 60,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.grey.shade300,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Authenticate.facebookSignIn();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: ImageIcon(
                            AssetImage("assets/facebook.png"),
                            color: Colors.blue
                                .shade800,
                            size: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            "Continue with Facebook",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Century Gothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
