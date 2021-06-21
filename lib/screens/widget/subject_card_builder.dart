import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/widget/subject.dart';


//This create a list of widgets showing cards of subjects
//add a add new subject card

List getSubjectWidgetList() {
  List <Widget> widgetList = [];
  for (var i = 0; i < subjects.length; i++) {
    final subject = subjects[i];
    final card = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      elevation: 3.0,
      child: Container(
        //margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: ListTile(
          title: Text(subject.subjectName),
          subtitle: Row(
            children: <Widget>[
              Text(subject.startTime),
              Text(' - '),
              Text(subject.endTime)
            ],
          ),
          trailing: Text(subject.hallName),
          onTap: () {},
        ),
      ),
    );
    widgetList.add(card);
  }
  // final addNewSubjectCard = Card(
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //   ),
  //   elevation: 3.0,
  //   child: Container(
  //     margin: EdgeInsets.only(top:10.0),
  //     child: ListTile(
  //       title: Text(
  //         'Add new Subject',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle:  IconButton(
  //         icon: Icon(Icons.add),
  //         iconSize: 30.0,
  //       ),
  //       onTap: () {},
  //     ),
  //   ),
  // );
  // widgetList.add(addNewSubjectCard);
  return widgetList;
}