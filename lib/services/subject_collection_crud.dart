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
    CollectionReference subjectTasks = FirebaseFirestore.instance.collection('SubjectTask');
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
    QuerySnapshot subjectTask = await subjectTasks.where('course_Code', isEqualTo: subjectCode).get();
    subjectTask.docs.forEach((doc3) {
      subjectTasks.doc(doc3.id).delete().then((value) => print('Deleted')).
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

  Future<void> deleteSubjectTimeSlotData(docId) async{
    CollectionReference subjectTimeSlot = FirebaseFirestore.instance.collection('SubjectTimeSlot');
    subjectTimeSlot.doc(docId).delete().then((value) => print('deleted')).
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

  Future<void> addSubjectTaskData(subjectCode, title, description, date, time) async{
    CollectionReference subjectTask = FirebaseFirestore.instance.collection('SubjectTask');
    subjectTask.add({
      'course_Code': subjectCode,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> editSubjectTaskData(taskId ,subjectCode, title, description, date, time) async{
    CollectionReference subjectTask = FirebaseFirestore.instance.collection('SubjectTask');
    subjectTask.doc(taskId).set({
      'course_Code': subjectCode,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> deleteSubjectTaskData(docId) async{
    CollectionReference subjectTask = FirebaseFirestore.instance.collection('SubjectTask');
    subjectTask.doc(docId).delete().then((value) => print('deleted')).
    catchError((e) => {print(e)});
  }

  Future<void> addSeminarData(userId, seminarName, seminarDescription) async{
    CollectionReference seminars = FirebaseFirestore.instance.collection('Seminar');
    seminars.add({
      'seminar_Name': seminarName,
      'seminar_Description': seminarDescription,
      'lecturer_ID' : userId,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> deleteSeminarData(seminarId) async{
    CollectionReference seminars = FirebaseFirestore.instance.collection('Seminar');
    CollectionReference seminarGroups = FirebaseFirestore.instance.collection('SeminarGroup');
    CollectionReference seminarTimeSlots = FirebaseFirestore.instance.collection('SeminarTimeSlot');
    QuerySnapshot seminarGroup = await seminarGroups.where('seminar_Id', isEqualTo: seminarId).get();
    seminarGroup.docs.forEach((doc1) {
      seminarGroups.doc(doc1.id).delete().then((value) => print('Deleted')).
      catchError((e) => {print(e)});
    });
    QuerySnapshot seminarTimeSlot = await seminarTimeSlots.where('seminar_Id', isEqualTo: seminarId).get();
    seminarTimeSlot.docs.forEach((doc2) {
      seminarTimeSlots.doc(doc2.id).delete().then((value) => print('Deleted')).
      catchError((e) => {print(e)});
    });
    seminars.doc(seminarId).delete().then((value) => print('Deleted')).
    catchError((e) => {print(e)});
  }

  Future<void> editSeminarData(seminarId, userId, seminarName, seminarDescription) async{
    CollectionReference subjects = FirebaseFirestore.instance.collection('Seminar');
    subjects.doc(seminarId).set({
      'seminar_Name': seminarName,
      'seminar_Description': seminarDescription,
      'lecturer_ID' : userId,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> addSeminarTimeSlotData(seminarId, date, startTime, endTime, location) async{
    CollectionReference seminarTimeSlots = FirebaseFirestore.instance.collection('SeminarTimeSlot');
    seminarTimeSlots.add({
      'seminar_Id': seminarId,
      'date': date,
      'start_Time': startTime,
      'end_Time': endTime,
      'location': location,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> editSeminarTimeSlotData(seminarTimeSlotId, seminarId, date, startTime, endTime, location) async{
    CollectionReference subjectTask = FirebaseFirestore.instance.collection('SeminarTimeSlot');
    subjectTask.doc(seminarTimeSlotId).set({
      'seminar_Id': seminarId,
      'date': date,
      'start_Time': startTime,
      'end_Time': endTime,
      'location': location,
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> deleteSeminarTimeSlotData(docId) async{
    CollectionReference subjectTask = FirebaseFirestore.instance.collection('SeminarTimeSlot');
    subjectTask.doc(docId).delete().then((value) => print('deleted')).
    catchError((e) => {print(e)});
  }

  Future<void> addSeminarGroupData(seminarId, degree, year) async{
    CollectionReference subjectGroup = FirebaseFirestore.instance.collection('SeminarGroup');
    subjectGroup.add({
      'seminar_Id': seminarId,
      'degree': degree,
      'year': year
    }).then((value) => print('Added')).
    catchError((e) => {print(e)});
  }

  Future<void> deleteSeminarGroupData(docId) async{
    CollectionReference subjectGroup = FirebaseFirestore.instance.collection('SeminarGroup');
    subjectGroup.doc(docId).delete().then((value) => print('deleted')).
    catchError((e) => {print(e)});
  }
}