import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectServices{
  Future<List<String>> getSubjectList() async{
    List <String> subjectList = [];
    await FirebaseFirestore.instance.collection('Subjects').get().then((value) => {
      value.docs.forEach((element) {
        subjectList.add(element.id);
      })
    });
    return subjectList;
  }
}