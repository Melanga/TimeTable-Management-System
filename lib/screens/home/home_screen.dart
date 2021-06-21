import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/home/dash_board.dart';
import 'package:flutter_intelij/screens/home/settings_plane.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: <Widget>[
          SettingsPanel(),
          DashBoard(),
        ],
      )
    );
  }
}
