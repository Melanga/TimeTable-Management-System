import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';

class SubjectGroupBuilder extends StatefulWidget {
  const SubjectGroupBuilder(this.subjectCode, {Key key}) : super(key: key);
  final String subjectCode;

  @override
  _SubjectGroupBuilderState createState() => _SubjectGroupBuilderState();
}

class _SubjectGroupBuilderState extends State<SubjectGroupBuilder> {

  List <String>degreeList = ["IIT", "CST", "SCT", "MRT", "EAG", "AQT", "ANS"];
  List <String>yearList = ["100", "200", "300", "400"];
  String degreeDropDownValue;
  String yearDropDownValue;

  @override
  Widget build(BuildContext context) {
    Stream data = FirebaseFirestore.instance.collection("SubjectGroup").where('course_Code', isEqualTo: widget.subjectCode).snapshots();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Assign Groups", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: data,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((doc2) {
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        //shadowColor: Colors.white24,
                        color: Colors.white54,
                        child: ListTile(
                          title: Text(doc2.data()['degree']),
                          subtitle: Text(doc2.data()['year']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_forever, color: Colors.redAccent,),
                            onPressed: (){
                              SubjectCRUDMethods crud = new SubjectCRUDMethods();
                              crud.deleteSubjectGroupData(doc2.id);
                            },
                          ),
                          onTap: (){},
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text("Failed to load Data");
              }
            },
          ),
        ),
        Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 5,
            shadowColor: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    child: DropdownButton<String>(
                      value: degreeDropDownValue,
                      hint: Text("Select degree"),
                      items: degreeList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newDegreeDropDownValue) {
                        degreeDropDownValue = newDegreeDropDownValue;
                        setState(() {
                          degreeDropDownValue = newDegreeDropDownValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    value: yearDropDownValue,
                    hint: Text("Select year"),
                    items: yearList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newYearDropDownValue) {
                      yearDropDownValue = newYearDropDownValue;
                      if (degreeDropDownValue.isNotEmpty){
                        SubjectCRUDMethods crud = new SubjectCRUDMethods();
                        crud.addSubjectGroupData(widget.subjectCode, degreeDropDownValue, yearDropDownValue);
                      }
                      setState(() {
                        yearDropDownValue = newYearDropDownValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
