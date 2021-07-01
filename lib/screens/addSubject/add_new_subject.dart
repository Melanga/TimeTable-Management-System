import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/subject_time_slot_builder.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/constant.dart';

class AddNewSubject extends StatefulWidget {
  @override
  _AddNewSubjectState createState() => _AddNewSubjectState();
}

class _AddNewSubjectState extends State<AddNewSubject> {
  String subjectCode;
  String subjectName;
  DateTime startDate;
  DateTime endDate;
  String subjectNote = 'Empty';


  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012329),
        title: Text("Create Subject"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Color(0xFF003640),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Subject Code'),
                validator: (val) {
                  return val.isEmpty ? 'Enter Subject Code' : null;
                },
                onChanged: (inputValue)  {
                  setState(() => {subjectCode = inputValue});
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Subject Name'),
                validator: (val) {
                  return val.isEmpty ? 'Enter Subject Name' : null;
                },
                onChanged: (inputValue)  {
                  setState(() => {subjectName = inputValue});
                },
              ),
              /*SizedBox(height: 20.0,),
              Text("Select Start Date", style: textStyle,),
              ListTile(
                title: Text(
                  "Date: ${startDate.year}, ${startDate.month}, ${startDate.day}",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                onTap: _pickStartDate,
              ),
              SizedBox(height: 20.0,),
              Text("Select End Date", style: textStyle,),
              ListTile(
                title: Text(
                  "Date: ${endDate.year}, ${endDate.month}, ${endDate.day}",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                onTap: _pickEndDate,
              ),*/
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Subject Note'),
                onChanged: (inputValue)  {
                  if (inputValue != null){
                    setState(() => {subjectNote = inputValue});
                  }
                },
              ),
              SizedBox(height: 50.0,),
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
                  crud.addSubjectData(this.subjectCode, this.subjectName, this.subjectNote);
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 130.0,),
            ],
          ),
        ),
      ),
    );
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

}