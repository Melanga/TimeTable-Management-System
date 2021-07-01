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

  Future<void> deleteSubjectData(subjectCode) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('Subjects');
    CollectionReference subjectGroups = FirebaseFirestore.instance.collection('SubjectGroup');
    CollectionReference subjectTimeSlots = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    QuerySnapshot subjectGroup = await subjectGroups.where('course_Code', isEqualTo: subjectCode).get();
    subjectGroup.docs.forEach((doc1) {
      subjectGroups.doc(doc1.id).delete().then((value) => print('Deleted')).
      catchError((e) => {print(e)});
    });
    QuerySnapshot subjectTimeSlot = await subjectTimeSlots.where('course_Code', isEqualTo: subjectCode).get();
    subjectTimeSlot.docs.forEach((doc2) {
      subjectTimeSlots.doc(doc2.id).delete().then((value) => print('Deleted')).
      catchError((e) => {print(e)});
    });
    subjects.doc(subjectCode).delete().then((value) => print('Deleted')).
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

  Future<void> addSubjectGroupData(subjectCode, degree, year) async{
    CollectionReference subjectGroup = FirebaseFirestore.instance.collection('SubjectGroup');
    subjectGroup.add({
      'course_Code': subjectCode,
      'degree': degree,
      'year': year
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> deleteSubjectGroupData(docId) async{
    CollectionReference subjectGroup = FirebaseFirestore.instance.collection('SubjectGroup');
    subjectGroup.doc(docId).delete().then((value) => print('deleted')).
    catchError((e) => {print(e)});
  }
}