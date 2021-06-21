import 'package:flutter/material.dart';

class SettingsPanel extends StatefulWidget {
  @override
  _SettingsPanelState createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final List <String>settings = [
    'Task List',
    'Subjects',
    'Seminar & Workshops',
    'Notifications',
    'Advanced Options',
    'Personalize',
  ];

  double screenWidth, screenHeight;

  int selectedSetting;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.teal,
      child: Container(
        margin: EdgeInsets.only(left: 10.0, top: screenHeight * 0.2,),
        child: ListView.builder(
            itemCount: settings.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectedSetting = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    settings[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: selectedSetting == index ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              );
            })
      ),
    );
  }
}
