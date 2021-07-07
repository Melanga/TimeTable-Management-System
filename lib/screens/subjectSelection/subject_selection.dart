import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectSelection extends StatefulWidget {
  const SubjectSelection({Key key}) : super(key: key);

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {

  Stream subjects = FirebaseFirestore.instance.collection('Subjects').snapshots();
  List <String>subjectShowList = [""];
  Map<String, dynamic> savedSelectedSubjects = {};
  Map <String, bool> values = {};
  String userCategory = '';
  Map <String, String> yearMap = {
    "19" : "100",
    "18" : "200",
    "17" : "300",
    "16" : "400"
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubjectList();
    _categorizeUser();
    try {
      Future<Map<String, dynamic>> selectedSubjects = _getSelectedSubjects();
      selectedSubjects.then((value) {
        savedSelectedSubjects = value;
      });
    } catch (e) {
      print(e);
      print("error loading");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subject Selection"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: subjects,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView(
                children: snapshot.data.docs.map((subjectData) {
                  if(userCategory == "lecturer"){
                    if (savedSelectedSubjects.isNotEmpty){
                      values.putIfAbsent(subjectData.data()['subject_Name'], () => savedSelectedSubjects[subjectData.data()['subject_Name']]);
                    } else {
                      values.putIfAbsent(subjectData.data()['subject_Name'], () => false);
                    }
                    return Card(
                      child: CheckboxListTile(
                          title: Text(subjectData.data()['subject_Name']),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: values[subjectData.data()['subject_Name']],
                          onChanged: (value){
                            setState(() {
                              values[subjectData.data()['subject_Name']] = value;
                            });
                            //print(values);
                            _setSelectedSubjects();
                          }),
                    );
                  } else {
                    if(subjectShowList.contains(subjectData.id)) {
                      if (savedSelectedSubjects.isNotEmpty){
                        values.putIfAbsent(subjectData.data()['subject_Name'], () => savedSelectedSubjects[subjectData.data()['subject_Name']]);
                      } else {
                        values.putIfAbsent(subjectData.data()['subject_Name'], () => false);
                      }
                      return Card(
                        child: CheckboxListTile(
                            title: Text(subjectData.data()['subject_Name']),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: values[subjectData.data()['subject_Name']],
                            onChanged: (value){
                              setState(() {
                                values[subjectData.data()['subject_Name']] = value;
                              });
                              //print(values);
                              _setSelectedSubjects();
                            }),
                      );
                    } else {
                      return Text ("");
                    }
                  }
                }).toList(),
              );
            } else{
              return Text("Loading");
            }
          },
        ),
      ),
    );
  }
  
  _getSubjectList() async{
    List <String>returnSubjectList = [];
    final userEmail = FirebaseAuth.instance.currentUser.email;
    final String degree = userEmail.substring(0,3).toUpperCase();
    final String year = this.yearMap[userEmail.substring(3, 5)];
    QuerySnapshot subjectGroups = await FirebaseFirestore.instance.collection('SubjectGroup').where('degree', isEqualTo: degree).where('year', isEqualTo: year).get();
    subjectGroups.docs.forEach((subjectGroup) {
      returnSubjectList.add(subjectGroup.data()['course_Code']);
    });
    setState(() {
      this.subjectShowList = returnSubjectList;
    });
  }
  
  _setSelectedSubjects() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedSubjects', json.encode(values));
  }

  Future<Map<String, dynamic>> _getSelectedSubjects() async{
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> returnValues = json.decode(prefs.getString('selectedSubjects'));
    return returnValues;
  }

  _categorizeUser(){
    final userEmail = FirebaseAuth.instance.currentUser.email;
    if(userEmail.endsWith("@uwu.ac.lk")){
      setState(() => {this.userCategory = "lecturer"});
    } else if (userEmail.endsWith("@example.com")){
      setState(() => {this.userCategory = "student"});
    }
  }
}
