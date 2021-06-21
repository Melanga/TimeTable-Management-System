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
}