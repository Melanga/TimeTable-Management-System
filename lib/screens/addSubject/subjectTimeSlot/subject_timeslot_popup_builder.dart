import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/check_hall_availability.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';


class EditSubjectTimeSlotPopupBuilder extends StatefulWidget {
  const EditSubjectTimeSlotPopupBuilder(this.doc, this.subjectCode, {Key key}) : super(key: key);
  final QueryDocumentSnapshot doc;
  final String subjectCode;

  @override
  _EditSubjectTimeSlotPopupBuilderState createState() => _EditSubjectTimeSlotPopupBuilderState();
}

class _EditSubjectTimeSlotPopupBuilderState extends State<EditSubjectTimeSlotPopupBuilder> {
  TimeOfDay newStartTime;
  TimeOfDay newEndTime;
  String dropdownValue;
  //TimeOfDay newTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newStartTime = TimeOfDay(
        hour: int.parse(widget.doc.data()['start_Time'].toString().substring(0,2)),
        minute: int.parse(widget.doc.data()['start_Time'].toString().substring(6,7)));
    newEndTime = TimeOfDay(
        hour: int.parse(widget.doc.data()['end_Time'].toString().substring(0,2)),
        minute: int.parse(widget.doc.data()['end_Time'].toString().substring(6,7)));
    dropdownValue = widget.doc.data()['day'];
  }

  @override
  Widget build(BuildContext context) {

    String timeSlotId = widget.doc.id;
    String day = widget.doc.data()['day'];
    String location = widget.doc.data()['location'];
    String startTime = widget.doc.data()['start_Time'];
    String endTime = widget.doc.data()['end_Time'];
    TimeOfDay newStartTime = this.newStartTime;
    TimeOfDay newEndTime = this.newEndTime;
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
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward, color: Colors.white,),
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return dayList.map((String value) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                                dropdownValue,
                                style: const TextStyle(color: Colors.white,)
                            ),
                          );
                        }).toList();
                      },
                      items: dayList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.black),),
                        );
                      }).toList(),
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
                        "${newStartTime.hour.toString().padLeft(2, "0")} : ${newStartTime.minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      onTap: _pickStartTime,
                    ),
                    SizedBox(height: 20.0,),
                    Text(
                      "Select End Time",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "${newEndTime.hour.toString().padLeft(2, "0")} : ${newEndTime.minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      onTap: _pickEndTime,
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
                      onPressed: () async{
                        SubjectCRUDMethods crud = new SubjectCRUDMethods();
                        day = this.dropdownValue;
                        startTime = "${newStartTime.hour.toString().padLeft(2, "0")} : ${newStartTime.minute.toString().padLeft(2, "0")}";
                        endTime = "${newEndTime.hour.toString().padLeft(2, "0")} : ${newEndTime.minute.toString().padLeft(2, "0")}";
                        CheckHallAvailability chab = new CheckHallAvailability();
                        bool value = await chab.checkHallAvailability(day, location, newStartTime, newEndTime);
                        if (value != true){
                          crud.editSubjectTimeSlotData(widget.subjectCode, timeSlotId, startTime, day, endTime, location);
                          Navigator.pop(context);
                        } else {
                          _showDialog();
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


  _pickStartTime() async{
    TimeOfDay initTime = newStartTime;

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if(selectedTime != null){
      setState(() {
        newStartTime = selectedTime;
      });
    }
  }


  _pickEndTime() async{
    TimeOfDay initTime = newEndTime;

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if(selectedTime != null){
      setState(() {
        newEndTime = selectedTime;
      });
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("This Time Slot is not available"),
          content: new Text("Try another one"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
  String startTime;
  String endTime;
  String dropdownValue = 'Monday';
  TimeOfDay newStartTime;
  TimeOfDay newEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newStartTime = TimeOfDay.now();
    newEndTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay newStartTime = this.newStartTime;
    TimeOfDay newEndTime = this.newEndTime;
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
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward, color: Colors.white,),
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String newValue) {
                      this.day = newValue;
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return dayList.map((String value) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            dropdownValue,
                            style: const TextStyle(color: Colors.white,)
                          ),
                        );
                      }).toList();
                    },
                    items: dayList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
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
                      "${newStartTime.hour.toString().padLeft(2, "0")} : ${newStartTime.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    onTap: _pickStartTime,
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    "Select End Time",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${newEndTime.hour.toString().padLeft(2, "0")} : ${newEndTime.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    onTap: _pickEndTime,
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
                    onPressed: () async{
                      SubjectCRUDMethods crud = new SubjectCRUDMethods();
                      startTime = "${newStartTime.hour.toString().padLeft(2, "0")} : ${newStartTime.minute.toString().padLeft(2, "0")}";
                      endTime = "${newEndTime.hour.toString().padLeft(2, "0")} : ${newEndTime.minute.toString().padLeft(2, "0")}";
                      CheckHallAvailability chab = new CheckHallAvailability();
                      bool value = await chab.checkHallAvailability(this.day, this.location, newStartTime, newEndTime);
                      if (value != true){
                        crud.addSubjectTimeSlotData(widget.subjectCode, this.startTime, this.day, this.endTime, this.location);
                        Navigator.pop(context);
                      }
                      else{
                        _showDialog();
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
    );
  }

  _pickStartTime() async {
    TimeOfDay initTime = TimeOfDay.now();

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        newStartTime = selectedTime;
      });
    }
  }

  _pickEndTime() async{
    TimeOfDay initTime = TimeOfDay.now();

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if(selectedTime != null){
      setState(() {
        newEndTime = selectedTime;
      });
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("This Time Slot is not available"),
          content: new Text("Try another one"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

