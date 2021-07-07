import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/edit_subject_popup_builder.dart';
import 'package:flutter_intelij/services/get_selected_subjects.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubjectMap();
    _getSubjectList();
    _categorizeUser();
  }

  @override
  Widget build(BuildContext context) {

    //List <String>subjectList = ["IIT 222-3", "CST 223-3"];
    _setSubjectList();
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
                            Text(reverseSubjectMap[doc.data()['course_Code']]),
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
                                    child: ShowSubjectPopUpBuilder(subject)
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
            return Text("no data");
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
      returnSubject.add(this.subjectMap[element]);
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
      returnSubject.add(this.subjectMap[element]);
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
}


class ShowSubjectPopUpBuilder extends StatelessWidget {
  const ShowSubjectPopUpBuilder(this.doc, {Key key}) : super(key: key);

  final DocumentSnapshot doc;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(doc.data()["subject_Name"]),
                  Text(doc.data()["subject_note"])
                ],
              ),
            ),
          ),
        ),
    );
  }
}