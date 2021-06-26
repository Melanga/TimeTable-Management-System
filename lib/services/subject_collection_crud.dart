import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectCRUDMethods {
  Future<void> addSubjectData(subjectCode, subjectName, subjectNote) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('Subjects');
    subjects.doc(subjectCode).set({
      'subject_Name': subjectName,
      'subject_note': subjectNote,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> addSubjectTimeSlotData(subjectCode, startTime, day, endTime, location) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    subjects.add({
      'course_Code': subjectCode,
      'day': day,
      'start_Time': startTime,
      'end_Time': endTime,
      'location': location,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> editSubjectTimeSlotData(subjectCode, timeSlotId, startTime, day, endTime, location) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    subjects.doc(timeSlotId).set({
      'course_Code': subjectCode,
      'day': day,
      'start_Time': startTime,
      'end_Time': endTime,
      'location': location,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }
}