import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectSelection extends StatefulWidget {
  const SubjectSelection({Key key}) : super(key: key);

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {

  Stream subjects = FirebaseFirestore.instance.collection('Subjects').snapshots();
  List <String>subjectShowList = ["empty"];
  List <String>subjectList = [];
  List <String>finalSubjectList = [];
  Map<String, dynamic> savedSelectedSubjects = {};
  Map <String, bool> values = {};
  String userCategory = '';
  Map <String, String> yearMap = {};

  @override
  void initState() {
    super.initState();
    _setSubjectList();
    _categorizeUser();
    _getSubjectList();

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
        backgroundColor: Color(0xFF003640),
        title: Text("Subject Selection"),
      ),
      body: Column(
        children: [
          Visibility(
            visible: userCategory == "lecturer",
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff107272),
              ),
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white70,
                onSubmitted: _searchOperation,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff107272),
              ),
              padding: EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Subjects').where(FieldPath.documentId, whereIn: subjectShowList).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView(
                      children: snapshot.data.docs.map((subjectData) {
                        if(userCategory == "lecturer"){
                          if (savedSelectedSubjects.isNotEmpty && savedSelectedSubjects.length<values.length){
                            values.putIfAbsent(subjectData.data()['subject_Name'], () => savedSelectedSubjects[subjectData.data()['subject_Name']] );
                          } else {
                            values.putIfAbsent(subjectData.data()['subject_Name'], () => savedSelectedSubjects[subjectData.data()['subject_Name']] ?? false);
                          }
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CheckboxListTile(
                                title: Text(subjectData.data()['subject_Name']),
                                subtitle: Text(subjectData.id),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  _getSubjectList() async{
    await _setYearMap();
    List <String>returnSubjectList = [];
    final userEmail = FirebaseAuth.instance.currentUser.email;
    final String degree = userEmail.substring(0,3).toUpperCase();
    final String year = yearMap[userEmail.substring(3, 5)];
    if(userCategory == "lecturer"){
      await FirebaseFirestore.instance.collection('Subjects').where(FieldPath.documentId, whereIn: this.subjectList).get().then((doc) {
        if(doc != null){
          doc.docs.forEach((element) {
            returnSubjectList.add(element.id);
          });
        }
      });
    } else {
      QuerySnapshot subjectGroups = await FirebaseFirestore.instance.collection('SubjectGroup').where('degree', isEqualTo: degree).get();
      subjectGroups.docs.forEach((subjectGroup) {
        if(subjectGroup.data()['year'] == year) {
          returnSubjectList.add(subjectGroup.data()['course_Code']);
        }
      });
    }
    setState(() {
      if(returnSubjectList.isEmpty){
        this.subjectShowList = ["empty"];
      }else{
        this.subjectShowList = returnSubjectList;
      }
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
    } else if (userEmail.endsWith("@std.uwu.ac.lk")){
      setState(() => {this.userCategory = "student"});
    }
  }

  _setYearMap() async{
    await FirebaseFirestore.instance.collection("SemesterData").get().then((doc) {
      if(doc != null){
        doc.docs.forEach((element) {
          yearMap[element.data()['email_No'].toString()] = element.id;
        });
      }
    });
    setState(() {
    });
  }

  _setSubjectList() async{
    List <String> subjectList = await SubjectServices().getSubjectList();
    setState(() {
      this.subjectList = subjectList;
      this.subjectShowList = subjectList;
      this.finalSubjectList = subjectList;
    });
  }

  _searchOperation(String searchText){
    List<String> searchResult = [];
    this.finalSubjectList.forEach((subject) {
      if (subject.toLowerCase().contains(searchText.toLowerCase())){
        searchResult.add(subject);
      }
    });
    setState(() {
      if(searchResult.isEmpty){
        this.subjectList = ["empty"];
      } else {
        this.subjectList = searchResult;
      }
    });
    _getSubjectList();
  }
}
