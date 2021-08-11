import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/subjectTask/subject_task_popup_builder.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';

class SubjectTaskBuilder extends StatefulWidget {
  const SubjectTaskBuilder(this.subjectCode, {Key key}) : super(key: key);

  final String subjectCode;
  @override
  _SubjectTaskBuilderState createState() => _SubjectTaskBuilderState();
}

class _SubjectTaskBuilderState extends State<SubjectTaskBuilder> {
  @override
  Widget build(BuildContext context) {

    Stream data = FirebaseFirestore.instance.collection("SubjectTask").where('course_Code', isEqualTo: widget.subjectCode).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: data,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((doc) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.blueGrey,
                child: ListTile(
                  title: Text(doc.data()['title']),
                  subtitle: Text(doc.data()['description']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(doc.data()['date']),
                      Text(doc.data()['time']),
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      HeroDialogRoute(
                        builder: (context) => Center(
                            child: EditSubjectTask(doc, widget.subjectCode)
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        } else {
          return Text("Loading");
        }
      },
    );
  }
}
