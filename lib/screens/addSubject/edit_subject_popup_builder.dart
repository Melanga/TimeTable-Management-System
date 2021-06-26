import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/subject_time_slot_builder.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/constant.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';

import 'subject_timeslot_popup_builder.dart';

class EditSubjectPopUpBuilder extends StatefulWidget {
  const EditSubjectPopUpBuilder(this.doc, {Key key}) : super(key: key);
  final QueryDocumentSnapshot doc;
  @override
  _EditSubjectPopUpBuilderState createState() => _EditSubjectPopUpBuilderState();
}

class _EditSubjectPopUpBuilderState extends State<EditSubjectPopUpBuilder> {

  @override
  Widget build(BuildContext context) {
    String subjectCode = widget.doc.id;
    String subjectName = widget.doc.data()['subject_Name'];
    DateTime startDate = widget.doc.data()['start_date'].toDate();
    DateTime endDate = widget.doc.data()['end_date'].toDate();
    String subjectNote = widget.doc.data()['subject_note'];
    return Hero(
      tag: widget.doc.id,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: subjectCode,
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      subjectCode = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: subjectName,
                    onChanged: (inputValue)  {
                      subjectName = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Select Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text(
                      "Date: ${startDate.year}, ${startDate.month}, ${startDate.day}",
                      style: TextStyle(),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () {},
                  ),
                  SizedBox(height: 20.0,),
                  Text("Select End Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text(
                      "Date: ${endDate.year}, ${endDate.month}, ${endDate.day}",
                      style: TextStyle(),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: (){},
                  ),
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
                  Text("Add subject note", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    initialValue: subjectNote,
                    onChanged: (inputValue)  {
                      subjectNote = inputValue;
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
                      crud.addSubjectData(subjectCode,  subjectName, startDate, endDate, subjectNote);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  //subjectTimeSlotBuilder(subjectCode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
