
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckHallAvailability{
  Future<bool> checkHallAvailability(String day, String location, TimeOfDay startTime, TimeOfDay endTime) async{
    double startA = startTime.hour + (startTime.minute/100);
    double endA = endTime.hour + (endTime.minute/100);
    bool value = false;
    QuerySnapshot data = await FirebaseFirestore.instance.collection("SubjectTimeSlot").where('day', isEqualTo: day).get();
    data.docs.forEach((element) {
      if(element.data()['location'].toString().contains(location)){
        String startB1 = element.data()['start_Time'];
        String endB1 = element.data()['end_Time'];
        double startB = double.parse(startB1.substring(0, 2)) + (double.parse(startB1.substring(5,7))/100);
        double endB = double.parse(endB1.substring(0, 2)) + (double.parse(endB1.substring(5,7))/100);
        // this check the time slots collide each other
        if ((startA < endB) && (endA > startB)){
          value = true;
        }
      }
    });
    return value;
  }
}