import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/widget/subject_card_builder.dart';
import 'package:flutter_intelij/screens/widget/week_days_bar.dart';
import 'package:flutter_intelij/services/auth.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isCollapsed = true;
  double screenHeight, screenWidth;
  final Duration duration = const Duration(milliseconds: 300);
  final AuthSevice _auth = AuthSevice();

  @override
  Widget build(BuildContext context) {
    //get the height and width of the device for responsive design
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      // set the position of the Scaffold by checking isCollapsed property
      top: isCollapsed ? 0.0 : 0.0 * screenHeight,
      bottom: isCollapsed ? 0.0 : 0.0 * screenHeight,
      left: isCollapsed ? 0.0 : 0.65 * screenWidth,
      right: isCollapsed ? 0.0 : -0.65 * screenWidth,
      duration: duration,
      child: Scaffold(
        backgroundColor: Color(0xFF003640),
        appBar: AppBar(
          backgroundColor: Color(0xFF003640),
          leading: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text("Logout", style: TextStyle(
                color: Colors.white,
              ),
              ),
              onPressed: () async{
                _auth.signOut();
              },
            )
          ],
          title: Text('TimeTable',
          style: TextStyle(
            fontSize:  28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            WeekDaysBar(),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details){
                  if (details.primaryDelta < 0.0){
                  setState(() {
                    isCollapsed = true;
                  });}
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)
                    )
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                    child: ListView(
                      children: getSubjectWidgetList(),
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
