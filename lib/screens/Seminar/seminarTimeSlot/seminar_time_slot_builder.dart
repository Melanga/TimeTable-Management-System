import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';


class SeminarTimeSlotBuilder extends StatefulWidget {
  const SeminarTimeSlotBuilder(this.seminarId, this.clickable, {Key key}) : super(key: key);

  final String seminarId;
  final bool clickable;
  @override
  _SeminarTimeSlotBuilderState createState() => _SeminarTimeSlotBuilderState();
}

class _SeminarTimeSlotBuilderState extends State<SeminarTimeSlotBuilder> {
  @override
  Widget build(BuildContext context) {

    Stream data = FirebaseFirestore.instance.collection("SeminarTimeSlot").where('seminar_Id', isEqualTo: widget.seminarId).snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: data,
        builder: (context, snapshot2){
          if (snapshot2.hasData){
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot2.data.docs.map((doc2) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadowColor: Colors.teal,
                    color: Color(0x9fe3bf),
                    child: ListTile(
                      title: Text(doc2.data()['date']),
                      subtitle: Text("${doc2.data()['start_Time']} to ${doc2.data()['end_Time']}"),
                      trailing: Text(doc2.data()['location']),
                      onTap: (){
                        if(widget.clickable){
                          Navigator.of(context).push(
                            HeroDialogRoute(
                              builder: (context) => Center(
                                  child: EditSeminarTimeSLotPopupBuilder(doc2, widget.seminarId)
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Text("no data");
          }
        }
    );
  }
}

class EditSeminarTimeSLotPopupBuilder extends StatefulWidget {
  const EditSeminarTimeSLotPopupBuilder(this.seminarTimeSlot, this.seminarId, {Key key}) : super(key: key);

  final QueryDocumentSnapshot seminarTimeSlot;
  final String seminarId;

  @override
  _EditSeminarTimeSLotPopupBuilderState createState() => _EditSeminarTimeSLotPopupBuilderState();
}

class _EditSeminarTimeSLotPopupBuilderState extends State<EditSeminarTimeSLotPopupBuilder> {

  String date;
  String startTime;
  String endTime;
  String location;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 12, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 12, minute: 00);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      date = widget.seminarTimeSlot.data()['date'];
      startTime = widget.seminarTimeSlot.data()['start_Time'];
      endTime = widget.seminarTimeSlot.data()['end_Time'];
      location = widget.seminarTimeSlot.data()['location'];
      selectedDate = DateTime.parse(date);
      selectedStartTime = TimeOfDay(
          hour: int.parse(startTime.substring(0,2)),
          minute: int.parse(startTime.substring(5,7)));
      selectedEndTime = TimeOfDay(
          hour: int.parse(endTime.substring(0,2)),
          minute: int.parse(endTime.substring(5,7)));
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
                        onTap: () => {_pickStartTime()},
                        title: Text("Select Start Time", style: TextStyle(fontSize: 16),),
                        trailing: Text("${selectedStartTime.hour.toString().padLeft(2, "0")} : ${selectedStartTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
                    ),
                  ),
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
                        onTap: () => {_pickEndTime()},
                        title: Text("Select End Time", style: TextStyle(fontSize: 16),),
                        trailing: Text("${selectedEndTime.hour.toString().padLeft(2, "0")} : ${selectedEndTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: location,
                  onChanged: (inputValue)  {
                    location = inputValue;
                    setState(() => {location = inputValue});
                  },
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
                    startTime = "${selectedStartTime.hour.toString().padLeft(2, "0")} : ${selectedStartTime.minute.toString().padLeft(2, "0")}";
                    endTime = "${selectedEndTime.hour.toString().padLeft(2, "0")} : ${selectedEndTime.minute.toString().padLeft(2, "0")}";
                    date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}";
                    if(startTime.isNotEmpty && date.isNotEmpty && endTime.isNotEmpty){
                      crud.editSeminarTimeSlotData(widget.seminarTimeSlot.id, widget.seminarId, date, startTime, endTime, location);
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
                    crud.deleteSeminarTimeSlotData(widget.seminarTimeSlot.id);
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

  _pickStartTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedStartTime = selectedTime;
      });
    }
  }

  _pickEndTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedEndTime = selectedTime;
      });
    }
  }
}


class AddNewSeminarTimeSlotPopupBuilder extends StatefulWidget {
  const AddNewSeminarTimeSlotPopupBuilder(this.seminarId, {Key key}) : super(key: key);

  final String seminarId;

  @override
  _AddNewSeminarTimeSlotPopupBuilderState createState() => _AddNewSeminarTimeSlotPopupBuilderState();
}

class _AddNewSeminarTimeSlotPopupBuilderState extends State<AddNewSeminarTimeSlotPopupBuilder> {

  String date;
  String startTime;
  String endTime;
  String location;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 12, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 12, minute: 00);

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
                        onTap: () => {_pickStartTime()},
                        title: Text("Select Start Time", style: TextStyle(fontSize: 16),),
                        trailing: Text("${selectedStartTime.hour.toString().padLeft(2, "0")} : ${selectedStartTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
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
                        onTap: () => {_pickEndTime()},
                        title: Text("Select End Time", style: TextStyle(fontSize: 16),),
                        trailing: Text("${selectedEndTime.hour.toString().padLeft(2, "0")} : ${selectedEndTime.minute.toString().padLeft(2, "0")}", style: TextStyle(fontSize: 16))
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
                        title: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter Location"
                          ),
                          onChanged: (inputValue)  {
                            location = inputValue;
                            setState(() => {location = inputValue});
                          },
                        ),
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
                    startTime = "${selectedStartTime.hour.toString().padLeft(2, "0")} : ${selectedStartTime.minute.toString().padLeft(2, "0")}";
                    endTime = "${selectedEndTime.hour.toString().padLeft(2, "0")} : ${selectedEndTime.minute.toString().padLeft(2, "0")}";
                    date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}";
                    if(startTime.isNotEmpty && date.isNotEmpty){
                      crud.addSeminarTimeSlotData(widget.seminarId, date, startTime, endTime, location);
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

  _pickStartTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedStartTime = selectedTime;
      });
    }
  }

  _pickEndTime() async {
    TimeOfDay initTime = TimeOfDay(hour: 12, minute: 00);

    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: initTime
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedEndTime = selectedTime;
      });
    }
  }
}

