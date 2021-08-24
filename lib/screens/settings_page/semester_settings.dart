import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SemesterSettings extends StatefulWidget {
  const SemesterSettings({Key key}) : super(key: key);

  @override
  _SemesterSettingsState createState() => _SemesterSettingsState();
}

class _SemesterSettingsState extends State<SemesterSettings> {

  CollectionReference semesterData = FirebaseFirestore.instance.collection("SemesterData");
  Map <String, int> yearMap = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setYearMap();
  }

  @override
  Widget build(BuildContext context) {
    print(yearMap.values);
    return Scaffold(
      appBar: AppBar(
        title: Text("Semester Settings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xff107272),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: semesterData.snapshots(),
                      builder: (context, snapshot){
                        if (snapshot.hasData){
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data.docs.map((doc) {
                              return Hero(
                                tag: doc.id,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      title: Text(doc.id),
                                      trailing: Text(doc.data()['email_No'].toString(), maxLines: 1,),
                                      //trailing: Text(doc.data()['location']),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 20, 100, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: ()=>{_decrementSemester()},
                            icon: Icon(Icons.minimize)),
                        IconButton(
                            onPressed: ()=>{_incrementSemester()},
                            icon: Icon(Icons.add))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _incrementSemester(){
    yearMap.keys.forEach((year) {
      semesterData.doc(year).update({'email_No': (yearMap[year]+1)});
    });
    //semesterData.doc("100").update({'email_No': semesterData.doc('100')['email_No']+1})
  }
  _decrementSemester(){
    yearMap.keys.forEach((year) {
      semesterData.doc(year).update({'email_No': (yearMap[year]-1)});
    });
  }
  _setYearMap() async{
    await semesterData.get().then((doc) {
      if(doc != null){
        doc.docs.forEach((element) {
          yearMap[element.id] = element.data()['email_No'];
        });
      }
    });
  }
}
