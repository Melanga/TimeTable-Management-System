import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/subjectGroup/subject_group_builder.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTask/subject_task_builder.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTask/subject_task_popup_builder.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTimeSlot/subject_time_slot_builder.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/constant.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';

import 'subjectTimeSlot/subject_timeslot_popup_builder.dart';

class EditSubjectPopUpBuilder extends StatefulWidget {
  const EditSubjectPopUpBuilder(this.doc, {Key key}) : super(key: key);
  final DocumentSnapshot doc;
  @override
  _EditSubjectPopUpBuilderState createState() => _EditSubjectPopUpBuilderState();
}

class _EditSubjectPopUpBuilderState extends State<EditSubjectPopUpBuilder> {

  String newSubjectCode = "";
  String newSubjectName = "";
  String newSubjectNote = "";

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    String subjectCode = widget.doc.id;
    String subjectName = widget.doc.data()['subject_Name'];
    String subjectNote = widget.doc.data()['subject_note'];
    return Hero(
      tag: widget.doc.id,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              )
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: subjectCode,
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      this.newSubjectCode = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: subjectName,
                    onChanged: (inputValue)  {
                      this.newSubjectName = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  SubjectTimeSlotBuilder(subjectCode),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        HeroDialogRoute(
                          builder: (context) => Center(
                              child: AddNewSubjectTimeSlotPopupBuilder(subjectCode)
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xf2f2f2),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0,12,0,0),
                        child: Column(
                          children: [
                            Text(
                              "Add Subject Time Slot",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(icon: Icon(Icons.add), onPressed: (){
                              Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (context) => Center(
                                      child: AddNewSubjectTimeSlotPopupBuilder(subjectCode)
                                  ),
                                ),
                              );
                            },alignment: Alignment.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  SubjectGroupBuilder(subjectCode),
                  SizedBox(height: 20.0,),
                  Text("Subject Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
                  SubjectTaskBuilder(subjectCode),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.green,
                    elevation: 4,
                    child:Padding(
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(
                            HeroDialogRoute(
                              builder: (context) => Center(
                                child: AddNewSubjectTask(subjectCode),
                              ),
                            ),
                          );
                        },
                        title: Text("Add Subject Task"),
                        trailing: Icon(Icons.add),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Add subject note", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    initialValue: subjectNote,
                    onChanged: (inputValue)  {
                      this.newSubjectNote = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.cyan),
                    ),
                    onPressed: () {
                      SubjectCRUDMethods crud = new SubjectCRUDMethods();
                      crud.addSubjectData(subjectCode,  this.newSubjectName, this.newSubjectNote);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      SubjectCRUDMethods crud = new SubjectCRUDMethods();
                      crud.deleteSubjectData(subjectCode);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
