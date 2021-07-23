import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/edit_subject_popup_builder.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTask/subject_task_builder.dart';
import 'package:flutter_intelij/services/daily_notification.dart';
import 'package:flutter_intelij/services/get_selected_subjects.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SubjectCardBuilder extends StatefulWidget {
  const SubjectCardBuilder(this.selectedDay, {Key key}) : super(key: key);

  final String selectedDay;

  @override
  _SubjectCardBuilderState createState() => _SubjectCardBuilderState();
}

class _SubjectCardBuilderState extends State<SubjectCardBuilder> {

  List <String>subjectList = [""];
  Map <String, String>subjectMap = {};
  Map <String, String>reverseSubjectMap = {};
  String userCategory = '';
  TimeOfDay initTime = new TimeOfDay(hour: 7, minute: 0);
  bool isNotificationOn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubjectMap();
    _getSubjectList();
    _categorizeUser();
    _setIsNotificationOn();
  }

  @override
  void didUpdateWidget(covariant SubjectCardBuilder oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _getSubjectMap();
    _getSubjectList();
    _setIsNotificationOn();
  }

  @override
  Widget build(BuildContext context) {

    //List <String>subjectList = ["IIT 222-3", "CST 223-3"];
    /*if(subjectMap.isNotEmpty){
      _setSubjectList();

    }*/
    if(reverseSubjectMap.isNotEmpty && subjectList.isNotEmpty){
      DailyNotification dailyNotification = new DailyNotification();
      if(this.isNotificationOn){
        dailyNotification.setDailyNotifications(subjectList, reverseSubjectMap);
      }else {
        dailyNotification.cancelDailyNotifications();
      }
      dailyNotification.setTaskNotifications(subjectList, reverseSubjectMap);
    }
    Stream stream = FirebaseFirestore.instance.collection("SubjectTimeSlot").where('day', isEqualTo: widget.selectedDay).where('course_Code', whereIn: this.subjectList).snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot){
          if (snapshot.hasData){
            return ListView(
              children: snapshot.data.docs.map((doc) {
                return Hero(
                  tag: doc.id,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        title: Row(
                          children: [
                            Text(reverseSubjectMap[doc.data()['course_Code']]??"loading"),
                            Text("  (${doc.data()['course_Code']})")
                          ],
                        ),
                        //title: Text(doc.data()['course_Code']),
                        subtitle: Row(
                          children: <Widget>[
                            Text(doc.data()['start_Time']),
                            Text(' to '),
                            Text(doc.data()['end_Time']),
                          ],
                        ),
                        trailing: Text(doc.data()['location']),
                        onTap: () async{
                          DocumentSnapshot subject = await FirebaseFirestore.instance.collection('Subjects').doc(doc.data()['course_Code']).get();
                          if(userCategory == "lecturer"){
                            Navigator.of(context).push(
                              HeroDialogRoute(
                                builder: (context) => Center(
                                    child: EditSubjectPopUpBuilder(subject)
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              HeroDialogRoute(
                                builder: (context) => Center(
                                    child: ShowSubjectPopUpBuilder(subject, doc)
                                ),
                              ),
                            );
                          }

                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Loading Data...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
                textAlign: TextAlign.center,),
              ],
            );
          }
        }
    );
  }


  _categorizeUser(){
    final userEmail = FirebaseAuth.instance.currentUser.email;
    if(userEmail.endsWith("@uwu.ac.lk")){
      setState(() => {this.userCategory = "lecturer"});
    } else if (userEmail.endsWith("@example.com")){
      setState(() => {this.userCategory = "student"});
    }
  }

  _getSubjectList() async{
    GetSelectedSubjects getSelectedSubjects = new GetSelectedSubjects();
    List<String>selectedSubjects = await getSelectedSubjects.getSelectedSubjectList();
    List <String>returnSubject = [];
    await _getSubjectMap();
    selectedSubjects.forEach((element) {
      returnSubject.add(this.subjectMap[element]??"empty");
    });
    setState(() {
      this.subjectList = returnSubject;
    });
  }

  _setSubjectList() async{
    GetSelectedSubjects getSelectedSubjects = new GetSelectedSubjects();
    List<String>selectedSubjects = await getSelectedSubjects.getSelectedSubjectList();
    List <String>returnSubject = [];
    selectedSubjects.forEach((element) {
        returnSubject.add(this.subjectMap[element]??"empty");
    });
    this.subjectList = returnSubject;
  }

  _getSubjectMap() async{
    QuerySnapshot subjects = await FirebaseFirestore.instance.collection('Subjects').get();
    Map<String, String> subjectMap = {};
    Map<String, String> reverseSubjectMap = {};
    subjects.docs.forEach((subject) {
      subjectMap[subject.data()['subject_Name']] = subject.id;
    });
    reverseSubjectMap = subjectMap.map((key, value) => MapEntry(value, key));
    setState(() {
      this.reverseSubjectMap = reverseSubjectMap;
      this.subjectMap = subjectMap;
    });
  }

  _setIsNotificationOn() async{
    final prefs = await SharedPreferences.getInstance();
    bool value = true;
    try {
      value = prefs.getBool("isNotificationOn");
    } catch (e){
      value = true;
    }
    setState(() {
      this.isNotificationOn = value;
    });
  }
}


class ShowSubjectPopUpBuilder extends StatefulWidget {
  const ShowSubjectPopUpBuilder(this.subject, this.timeslot, {Key key}) : super(key: key);

  final DocumentSnapshot subject;
  final QueryDocumentSnapshot timeslot;

  @override
  _ShowSubjectPopUpBuilderState createState() => _ShowSubjectPopUpBuilderState();
}

class _ShowSubjectPopUpBuilderState extends State<ShowSubjectPopUpBuilder> {
  String subjectID = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      subjectID = widget.subject.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream data = FirebaseFirestore.instance.collection("SubjectTask").where('course_Code', isEqualTo: subjectID).snapshots();
    TextStyle _textStyle = new TextStyle(
      //fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    TextStyle _textLeadingStyle = new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Hero(
      tag: widget.timeslot.id,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(widget.subject.data()["subject_Name"] + "  ", style: _textLeadingStyle),
                        Text(widget.subject.id, style: _textStyle),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Text("Lecture Location : ", style: _textLeadingStyle,),
                        Text(widget.timeslot.data()["location"], style: _textStyle)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text("Duration : ", style: _textLeadingStyle,),
                        Text(widget.timeslot.data()["start_Time"] + " to " + widget.timeslot.data()["end_Time"], style: _textStyle)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text("Subject Note : ", style: _textLeadingStyle,),
                        Text(widget.subject.data()["subject_note"], style: _textStyle)
                      ],
                    ),
                    ShowSubjectTaskBuilder(subjectID),
                  ],
                ),
              ),
            ),
          ),
      ),
    );

  }
}

class ShowSubjectTaskBuilder extends StatefulWidget {
  const ShowSubjectTaskBuilder(this.subjectCode, {Key key}) : super(key: key);

  final String subjectCode;
  @override
  _ShowSubjectTaskBuilderState createState() => _ShowSubjectTaskBuilderState();
}

class _ShowSubjectTaskBuilderState extends State<ShowSubjectTaskBuilder> {
  @override
  Widget build(BuildContext context) {

    Stream data = FirebaseFirestore.instance.collection("SubjectTask").where('course_Code', isEqualTo: widget.subjectCode).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: data,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((doc) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white70,
                shadowColor: Colors.redAccent,
                child: ListTile(
                  title: Text(doc.data()['title']),
                  subtitle: Text(doc.data()['description']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(doc.data()['date']),
                      Text(doc.data()['time']),
                    ],
                  ),
                  onTap: (){},
                ),
              );
            }).toList(),
          );
        } else {
          return Text("Loading");
        }
      },
    );
  }
}