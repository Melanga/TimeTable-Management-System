import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/Seminar/seminarGroup/seminar_group.dart';
import 'package:flutter_intelij/screens/Seminar/seminarTimeSlot/seminar_time_slot_builder.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';

class EditSeminarPopUpBuilder extends StatefulWidget {
  const EditSeminarPopUpBuilder(this.seminar, {Key key}) : super(key: key);

  final QueryDocumentSnapshot seminar;

  @override
  _EditSeminarPopUpBuilderState createState() => _EditSeminarPopUpBuilderState();
}

class _EditSeminarPopUpBuilderState extends State<EditSeminarPopUpBuilder> {
  @override
  Widget build(BuildContext context) {

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    String seminarId = widget.seminar.id;
    String seminarName = widget.seminar.data()['seminar_Name'];
    String seminarDescription = widget.seminar.data()['seminar_Description'];
    String userId = FirebaseAuth.instance.currentUser.uid;

    return Hero(
      tag: widget.seminar.id,
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
                    initialValue: seminarName,
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      seminarName = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: null,
                    initialValue: seminarDescription,
                    onChanged: (inputValue)  {
                      seminarDescription = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  SeminarTimeSlotBuilder(seminarId, true),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Color(0xf2f2f2),
                    child: Container(
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(
                            HeroDialogRoute(
                              builder: (context) => Center(
                                  child: AddNewSeminarTimeSlotPopupBuilder(seminarId)
                              ),
                            ),
                          );
                        },
                        title: Text(
                            "Add Seminar Time Slot",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          trailing: Icon(Icons.add),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  SeminarGroupBuilder(seminarId),
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
                      crud.editSeminarData(seminarId, userId, seminarName, seminarDescription);
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
                      crud.deleteSeminarData(seminarId);
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


class ShowSeminarPopUpBuilder extends StatefulWidget {
  const ShowSeminarPopUpBuilder(this.seminar, {Key key}) : super(key: key);

  final QueryDocumentSnapshot seminar;

  @override
  _ShowSeminarPopUpBuilderState createState() => _ShowSeminarPopUpBuilderState();
}

class _ShowSeminarPopUpBuilderState extends State<ShowSeminarPopUpBuilder> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.seminar.id,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(widget.seminar.data()['seminar_Name']),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.seminar.data()['seminar_Description']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SeminarTimeSlotBuilder(widget.seminar.id, false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

