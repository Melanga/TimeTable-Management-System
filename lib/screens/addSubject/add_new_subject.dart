import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTimeSlot/subject_time_slot_builder.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/constant.dart';


class AddNewSubjectPopUp extends StatefulWidget {
  const AddNewSubjectPopUp({Key key}) : super(key: key);

  @override
  _AddNewSubjectPopUpState createState() => _AddNewSubjectPopUpState();
}

class _AddNewSubjectPopUpState extends State<AddNewSubjectPopUp> {

  String heroId = "subjectPopUp";
  String subjectCode;
  String subjectName;
  String subjectNote = "Empty";

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroId,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Align(
          alignment: Alignment.center,
          child: Card(
            //color: Color(0xFF003640),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Course Code"
                      ),
                      onChanged: (inputValue)  {
                        subjectCode = inputValue;
                        setState(() => {subjectCode = inputValue});
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Enter Subject Name"
                      ),
                      onChanged: (inputValue)  {
                        subjectName = inputValue;
                        setState(() => {subjectName = inputValue});
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Enter Subject Note"
                      ),
                      onChanged: (inputValue)  {
                        subjectNote = inputValue;
                        setState(() => {subjectNote = inputValue});
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
                        if(subjectCode.isNotEmpty){
                          crud.addSubjectData(this.subjectCode, this.subjectName, this.subjectNote);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*_pickStartDate() async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(DateTime.now().year -2),
        lastDate: DateTime(DateTime.now().year +2));
    if(selectedDate != null){
      setState(() {
        startDate = selectedDate;
      });
    }
  }

  _pickEndDate() async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(DateTime.now().year -2),
        lastDate: DateTime(DateTime.now().year +2));
    if(selectedDate != null){
      setState(() {
        endDate = selectedDate;
      });
    }
  }*/