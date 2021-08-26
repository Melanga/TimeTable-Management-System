import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class AddNewSubjectTask extends StatefulWidget {
  const AddNewSubjectTask(this.subjectCode, {Key key}) : super(key: key);

  final String subjectCode;
  @override
  _AddNewSubjectTaskState createState() => _AddNewSubjectTaskState();
}

class _AddNewSubjectTaskState extends State<AddNewSubjectTask> {

  String title;
  String description;
  String date;
  String time;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Title",
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    )
                  ),
                  onChanged: (inputValue)  {
                    title = inputValue;
                    setState(() => {title = inputValue});
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Description",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      )
                  ),
                  maxLines: null,
                  onChanged: (inputValue)  {
                    description = inputValue;
                    setState(() => {description = inputValue});
                  },
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListTile(
                      onTap: () => {_pickDate()},
                      title: Text("Select Date", style: TextStyle(fontSize: 16),),
                      trailing: Text("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListTile(
                      onTap: () => {_pickTime()},
                      title: Text("Select Time", style: TextStyle(fontSize: 16),),
                      trailing: Text("${selectedTime.hour.toString().padLeft(2, "0")} : ${selectedTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                    time = "${selectedTime.hour.toString().padLeft(2, "0")} : ${selectedTime.minute.toString().padLeft(2, "0")}";
                    date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}";
                    if(title.isNotEmpty && description.isNotEmpty && time.isNotEmpty && date.isNotEmpty){
                      crud.addSubjectTaskData(widget.subjectCode, title, description, date, time);
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
    );
  }

  _pickDate() async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: this.selectedDate,
        firstDate: DateTime(DateTime.now().year -2),
        lastDate: DateTime(DateTime.now().year +2));
    if(selectedDate != null){
      setState(() {
        this.selectedDate = selectedDate;
      });
    }
  }

  _pickTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedTime = selectedTime;
      });
    }
  }
}


//-------------------- Editing Subject Task -----------------------------------
class EditSubjectTask extends StatefulWidget {
  const EditSubjectTask(this.doc, this.subjectCode, {Key key}) : super(key: key);

  final QueryDocumentSnapshot doc;
  final String subjectCode;

  @override
  _EditSubjectTaskState createState() => _EditSubjectTaskState();
}

class _EditSubjectTaskState extends State<EditSubjectTask> {

  String title;
  String description;
  String date;
  String time;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 00);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      title = widget.doc.data()['title'];
      description = widget.doc.data()['description'];
      date = widget.doc.data()['date'];
      time = widget.doc.data()['time'];
      selectedDate = DateTime.parse(date);
      selectedTime = TimeOfDay(
          hour: int.parse(time.substring(0,2)),
          minute: int.parse(time.substring(5,7)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: title,
                  onChanged: (inputValue)  {
                    title = inputValue;
                    setState(() => {title = inputValue});
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: description,
                  maxLines: null,
                  onChanged: (inputValue)  {
                    description = inputValue;
                    setState(() => {description = inputValue});
                  },
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListTile(
                      onTap: () => {_pickDate()},
                      title: Text("Select Date", style: TextStyle(fontSize: 16),),
                      trailing: Text("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListTile(
                        onTap: () => {_pickTime()},
                        title: Text("Select Time", style: TextStyle(fontSize: 16),),
                        trailing: Text("${selectedTime.hour.toString().padLeft(2, "0")} : ${selectedTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                    time = "${selectedTime.hour.toString().padLeft(2, "0")} : ${selectedTime.minute.toString().padLeft(2, "0")}";
                    date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}";
                    if(title.isNotEmpty && description.isNotEmpty && time.isNotEmpty && date.isNotEmpty){
                      crud.editSubjectTaskData(widget.doc.id, widget.subjectCode, title, description, date, time);
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
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  ),
                  onPressed: () async{
                    SubjectCRUDMethods crud = new SubjectCRUDMethods();
                    crud.deleteSubjectTaskData(widget.doc.id);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: this.selectedDate,
        firstDate: DateTime(DateTime.now().year -2),
        lastDate: DateTime(DateTime.now().year +2));
    if(selectedDate != null){
      setState(() {
        this.selectedDate = selectedDate;
      });
    }
  }

  _pickTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedTime = selectedTime;
      });
    }
  }
}
