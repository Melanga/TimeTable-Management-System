import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/add_new_subject.dart';
import 'package:flutter_intelij/screens/addSubject/edit_subject_popup_builder.dart';
import 'package:flutter_intelij/services/get_selected_subjects.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';


class LecturerSubjects extends StatefulWidget {
  const LecturerSubjects({Key key}) : super(key: key);

  @override
  _LecturerSubjectsState createState() => _LecturerSubjectsState();
}

class _LecturerSubjectsState extends State<LecturerSubjects> {

  List <String>subjectList = [""];
  Map <String, String>subjectMap = {};
  Map <String, String>reverseSubjectMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubjectList();
  }
  @override
  Widget build(BuildContext context) {

    Stream stream = FirebaseFirestore.instance.collection("Subjects").where(FieldPath.documentId, whereIn: this.subjectList).snapshots();
    print(subjectList);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Subjects"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
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
                                        title: Text(doc.id),
                                        //title: Text(doc.data()['course_Code']),
                                        subtitle: Text(doc.data()['subject_Name']),
                                        onTap: () async{
                                          DocumentSnapshot subject = await FirebaseFirestore.instance.collection('Subjects').doc(doc.data()['course_Code']).get();
                                            Navigator.of(context).push(
                                              HeroDialogRoute(
                                                builder: (context) => Center(
                                                    child: EditSubjectPopUpBuilder(doc)
                                                ),
                                              ),
                                            );
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
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
              HeroDialogRoute(builder: (context) => Center(
                  child: AddNewSubjectPopUp()
              ))
          ).then((value) {
            setState(() {});
          },
          );
        },
      ),
    );
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
