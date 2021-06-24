import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/constant.dart';

Widget editSubjectTimeSlotPopupBuilder(QueryDocumentSnapshot doc){
  String subjectCode = doc.id;
  String day = doc.data()['date'];
  String location = doc.data()['location'];
  String duration = doc.data()['duration'].toString();
  String time = doc.data()['time'];

  return Hero(
    tag: doc.id,
    child: Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          color: Color(0xFF003640),
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
                    style: TextStyle(
                      color: Colors.white
                    ),
                    initialValue: day,
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      day = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: location,
                    onChanged: (inputValue)  {
                      location = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: time,
                    onChanged: (inputValue)  {
                      time = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: duration,
                    onChanged: (inputValue)  {
                      duration = inputValue;
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
                      crud.addSubjectData(subjectCode, time, day, duration, location);
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


// this out put the add new subject popup window
Widget addNewSubjectTimeSlotPopUpBuilder(String subjectCode){
  String day;
  String location;
  String duration;
  String time;

  return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          color: Color(0xFF003640),
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
                      hintText: "Enter Day",
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      )
                    ),
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: day,
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      day = inputValue;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Enter location",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        )
                    ),
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: location,
                    onChanged: (inputValue)  {
                      location = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Enter time",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        )
                    ),
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: time,
                    onChanged: (inputValue)  {
                      time = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Enter Duration",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        )
                    ),
                    style: TextStyle(
                        color: Colors.white
                    ),
                    initialValue: duration,
                    onChanged: (inputValue)  {
                      duration = inputValue;
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
                      crud.addSubjectTimeSlotData(subjectCode, time, day, duration, location);
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
    );
}

