import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/add_new_subject.dart';
import 'package:flutter_intelij/screens/home/admin_panel_widget.dart';
import 'package:flutter_intelij/services/auth.dart';

class AdminHomePage extends StatelessWidget {
  final AuthSevice _auth = AuthSevice();

  @override
  Widget build(BuildContext context) {
    // Act as the default home page.
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => AddNewSubject()));
        },
      ),
      appBar: AppBar(
        title: Text("Subjects"),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white,),
            label: Text("Logout", style: TextStyle(
              color: Colors.white,
            ),
            ),
            onPressed: () async{
              _auth.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Subjects").snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return ListView(
              children: snapshot.data.docs.map((doc) {
                return Card(
                  child: ListTile(
                    title: Text(doc.data()['subject_Name']),
                    subtitle: Text(doc.data()['start_date'].toDate()
                        .toString()
                        .substring(0, 10) + " to " + doc.data()['end_date']
                        .toDate().toString()
                        .substring(0, 10)),
                    trailing: Text(doc.id),
                  ),
                );
              }).toList(),
            );
          } else {
            return Text("no data");
          }
        }
      ),
    );
  }
}
