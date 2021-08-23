import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/Seminar/add_new_seminar.dart';
import 'package:flutter_intelij/screens/Seminar/seminar_pop_up_builder.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';


class SeminarScreen extends StatefulWidget {
  const SeminarScreen(this.userCategory, {Key key}) : super(key: key);

  final String userCategory;
  @override
  _SeminarScreenState createState() => _SeminarScreenState();
}

class _SeminarScreenState extends State<SeminarScreen> {
  List <String>subjectShowList = [""];
  Map <String, String> yearMap = {};
  String userId = FirebaseAuth.instance.currentUser.uid;
  Stream seminarStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setYearMap();
    _getSubjectList();
  }
  @override
  Widget build(BuildContext context) {
    Stream seminarStream;
    if(widget.userCategory == "lecturer"){
      seminarStream = FirebaseFirestore.instance.collection("Seminar").where('lecturer_ID', isEqualTo: this.userId).snapshots();
    } else {
      seminarStream = FirebaseFirestore.instance.collection("Seminar").where(FieldPath.documentId, whereIn: this.subjectShowList).snapshots();
    }
    //Stream seminarStream = FirebaseFirestore.instance.collection("Seminar").snapshots();
    print(this.subjectShowList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003640),
        title: Text("Seminar"),
      ),
      floatingActionButton: Visibility(
        visible: _setAddSeminarButtonVisibility(),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) => Center(
                    child: AddNewSeminarPopUp()
                ),
              ),
            );
          },
          icon: Icon(
            Icons.add,
          ),
          label: Text("add Seminar"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: seminarStream,
                          builder: (context, snapshot){
                            if (snapshot.hasData){
                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data.docs.map((doc) {
                                  return Hero(
                                    tag: doc.id,
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25)
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          title: Text(doc.data()['seminar_Name']),
                                          subtitle: Text(doc.data()['seminar_Description'], maxLines: 1,),
                                          //trailing: Text(doc.data()['location']),
                                          onTap: () async{
                                            if(_setAddSeminarButtonVisibility()){
                                              Navigator.of(context).push(
                                                HeroDialogRoute(
                                                  builder: (context) => Center(
                                                      child: EditSeminarPopUpBuilder(doc)
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.of(context).push(
                                                HeroDialogRoute(
                                                  builder: (context) => Center(
                                                      child: ShowSeminarPopUpBuilder(doc)
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Loading Data...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,),
                                ],
                              );
                            }
                          }
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
  bool _setAddSeminarButtonVisibility(){
    if(widget.userCategory == "lecturer"){
      return true;
    } else {
      return false;
    }
  }

  _getSubjectList() async{
    List <String>returnSubjectList = [];
    final userEmail = FirebaseAuth.instance.currentUser.email;
    final String degree = userEmail.substring(0,3).toUpperCase();
    final String year = this.yearMap[userEmail.substring(3, 5)];
    QuerySnapshot subjectGroups = await FirebaseFirestore.instance.collection('SeminarGroup').where('degree', isEqualTo: degree).where('year', isEqualTo: year).get();
    subjectGroups.docs.forEach((subjectGroup) {
      returnSubjectList.add(subjectGroup.data()['seminar_Id']);
    });
    setState(() {
      this.subjectShowList = returnSubjectList;
    });
  }

  _setYearMap() async{
    await FirebaseFirestore.instance.collection("SemesterData").get().then((doc) {
      if(doc != null){
        doc.docs.forEach((element) {
          yearMap[element.data()['email_No'].toString()] = element.id;
        });
      }
      setState(() {
      });
    });
  }
}
