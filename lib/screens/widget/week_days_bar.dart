import 'package:flutter/material.dart';

class WeekDaysBar extends StatefulWidget {
  @override
  _WeekDaysBarState createState() => _WeekDaysBarState();
}

class _WeekDaysBarState extends State<WeekDaysBar> {
  int selectedDay = 0;
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      color: Color(0xFF003640),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: weekDays.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
                child: Column(
                  children: [
                    Text(
                      weekDays[index],
                      style: TextStyle(
                        color: index == selectedDay ? Colors.white : Colors.white60,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
