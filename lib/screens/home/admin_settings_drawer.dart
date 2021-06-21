import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/auth.dart';

final AuthSevice _auth = AuthSevice();

Drawer adminSettingsDrawer = Drawer(
  elevation: 16,
  child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.teal,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment(0, -0.15),
          child: Text(
            'Settings',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )
              ),
              backgroundColor: MaterialStateProperty.all(Colors.cyan),
            ),
            onPressed: () {
              print('Button pressed ...');
            },
            child: Text(
              "Start New Semester",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )
              ),
              backgroundColor: MaterialStateProperty.all(Colors.cyan),
            ),
            onPressed: () {
              _auth.signOut();
            },
            child: Text(
              "Log Out",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

          ),
        )
      ],
    ),
  ),
);