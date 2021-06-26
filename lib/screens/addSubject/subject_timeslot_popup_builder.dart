import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';


class EditSubjectTimeSlotPopupBuilder extends StatefulWidget {
  const EditSubjectTimeSlotPopupBuilder(this.doc, this.subjectCode, {Key key}) : super(key: key);
  final QueryDocumentSnapshot doc;
  final String subjectCode;

  @override
  _EditSubjectTimeSlotPopupBuilderState createState() => _EditSubjectTimeSlotPopupBuilderState();
}

class _EditSubjectTimeSlotPopupBuilderState extends State<EditSubjectTimeSlotPopupBuilder> {
  TimeOfDay newTime;
  //TimeOfDay newTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newTime = TimeOfDay(
        hour: int.parse(widget.doc.data()['time'].toString().substring(0,2)),
        minute: int.parse(widget.doc.data()['time'].toString().substring(6,7)));
  }

  @override
  Widget build(BuildContext context) {

    String timeSlotId = widget.doc.id;
    String day = widget.doc.data()['date'];
    String location = widget.doc.data()['location'];
    String duration = widget.doc.data()['duration'].toString();
    String time = widget.doc.data()['time'];
    TimeOfDay newTime = this.newTime;
    List <String>dayList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    return Hero(
      tag: widget.doc.id,
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
                    Text(
                      "Select Start Time",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "${newTime.hour.toString().padLeft(2, "0")} : ${newTime.minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      onTap: _pickTime,
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
                        time = "${newTime.hour.toString().padLeft(2, "0")} : ${newTime.minute.toString().padLeft(2, "0")}";
                        crud.editSubjectTimeSlotData(widget.subjectCode, timeSlotId, time, day, duration, location);
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

  _pickTime() async{
    TimeOfDay initTime = newTime;

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if(selectedTime != null){
      setState(() {
        newTime = selectedTime;
      });
    }
  }
}


class AddNewSubjectTimeSlotPopupBuilder extends StatefulWidget {
  const AddNewSubjectTimeSlotPopupBuilder(this.subjectCode, {Key key}) : super(key: key);
  final String subjectCode;

  @override
  _AddNewSubjectTimeSlotPopupBuilderState createState() => _AddNewSubjectTimeSlotPopupBuilderState();
}

class _AddNewSubjectTimeSlotPopupBuilderState extends State<AddNewSubjectTimeSlotPopupBuilder> {
  String day;
  String location;
  String duration;
  String time;
  String dayDropDownValue;
  TimeOfDay newTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay newTime = this.newTime;
    this.dayDropDownValue = "Sunday";
    List <String>dayList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

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
                  /*DropdownButton(
                    value: dayDropDownValue,
                    onChanged: (newValue) {
                      setState(() {
                        this.dayDropDownValue = newValue;
                      });
                    },
                    items: dayList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),*/
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
                    //this create new subject fix it
                    onChanged: (inputValue)  {
                      this.day = inputValue;
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
                    onChanged: (inputValue)  {
                      this.location = inputValue;
                    },
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    "Select Start Time",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${newTime.hour.toString().padLeft(2, "0")} : ${newTime.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    onTap: _pickTime,
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
                    onChanged: (inputValue)  {
                      this.duration = inputValue;
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
                      time = "${newTime.hour.toString().padLeft(2, "0")} : ${newTime.minute.toString().padLeft(2, "0")}";
                      crud.addSubjectTimeSlotData(widget.subjectCode, this.time, this.day, this.duration, this.location);
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

  _pickTime() async{
    TimeOfDay initTime = TimeOfDay.now();

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if(selectedTime != null){
      setState(() {
        newTime = selectedTime;
      });
    }
  }
}
