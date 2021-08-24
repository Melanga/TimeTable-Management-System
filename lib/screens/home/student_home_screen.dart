import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/home/student_settings_plane.dart';
import 'package:flutter_intelij/screens/lecturer/lecturer_subjects.dart';
import 'package:flutter_intelij/screens/widget/subject_card_builder.dart';
import 'package:flutter_intelij/services/auth.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {

  final AuthSevice _auth = AuthSevice();
  int selectedDay = (DateTime.now().weekday)-1;
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> weekDaysFirebase = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String userCategory = "";
  bool buttonVisibility = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categorizeUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF003640),
      appBar: AppBar(
        backgroundColor: Color(0xFF003640),
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () async {
            scaffoldKey.currentState.openDrawer();
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
      drawer: SettingsPanel(this.userCategory),
      onDrawerChanged: (isOpen) {
        if(!isOpen){
          setState(() => {});
        }
      },
      body: Column(
        children: <Widget>[
          // Week Days bar
          Container(
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
          ),
          Expanded(
            child: Container(
                  decoration: BoxDecoration(
                      color: Color( 0xff107272),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)
                      )
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                    child: SubjectCardBuilder(weekDaysFirebase[selectedDay]),
                  )
              ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: buttonVisibility,
        child: FloatingActionButton.extended(
          label: Text("My Subjects"),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LecturerSubjects(),
              ),
            ).then((value) {
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  _categorizeUser(){
    final userEmail = FirebaseAuth.instance.currentUser.email;
    if(userEmail.endsWith("@uwu.ac.lk")){
      setState(() {
        this.userCategory = "lecturer";
        buttonVisibility = true;
      });
    } else if (userEmail.endsWith("@std.uwu.ac.lk")){
      setState(() => {this.userCategory = "student"});
    }
  }
}
