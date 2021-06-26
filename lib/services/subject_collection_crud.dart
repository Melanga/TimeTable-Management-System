import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectCRUDMethods {
  Future<void> addSubjectData(subjectCode, subjectName, startDate, endDate, subjectNote) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('Subjects');
    subjects.doc(subjectCode).set({
      'subject_Name': subjectName,
      'start_date': startDate,
      'end_date': endDate,
      'subject_note': subjectNote,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> addSubjectTimeSlotData(subjectCode, time, day, duration, location) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    subjects.add({
      'course_Code': subjectCode,
      'date': day,
      'duration': duration,
      'location': location,
      'time': time,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> editSubjectTimeSlotData(subjectCode, timeSlotId, time, day, duration, location) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    subjects.doc(timeSlotId).set({
      'course_Code': subjectCode,
      'date': day,
      'duration': duration,
      'location': location,
      'time': time,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }
}