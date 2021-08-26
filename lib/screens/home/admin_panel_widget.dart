import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/add_new_subject.dart';
import 'package:flutter_intelij/screens/addSubject/edit_subject_popup_builder.dart';
import 'package:flutter_intelij/screens/home/admin_settings_drawer.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/services/subject_services.dart';
import 'package:flutter_intelij/shared/hero_dialog_route.dart';


class AdminPanelWidget extends StatefulWidget {
  AdminPanelWidget({Key key}) : super(key: key);

  @override
  _AdminPanelWidgetState createState() => _AdminPanelWidgetState();
}

class _AdminPanelWidgetState extends State<AdminPanelWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthSevice _auth = AuthSevice();
  List<String> finalSubjectList = [];
  List<String> subjectList;


  @override
  void initState() {
    super.initState();
    _setSubjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0x00606b),
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: IconButton(
            onPressed: () async {
              scaffoldKey.currentState.openDrawer();
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            iconSize: 30,
          ),
        ),
        title: Text(
          'Time Table Management',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Color(0xFF003640),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            HeroDialogRoute(builder: (context) => Center(
                child: AddNewSubjectPopUp()
            ))
          ).then((value) {
            _setSubjectList();
          });
        },
        backgroundColor: Color(0x00606b),
        icon: Icon(
          Icons.add,
        ),
        label: Text(
          'Add Subjects',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
      drawer: AdminSettingsDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF003640),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Department of Computer Scienc and Infromatics',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: CupertinoSearchTextField(
                itemColor: Colors.white,
                backgroundColor: Colors.teal,
                placeholderStyle: TextStyle(
                  color: Colors.white70
                ),
                borderRadius: BorderRadius.circular(25),
                onSubmitted: _searchOperation,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF003640),
                ),
                alignment: Alignment(0, 0),
                child: Align(
                  alignment: Alignment(0, 0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF012329),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection("Subjects").where(FieldPath.documentId, whereIn: subjectList).snapshots(),
                                  builder: (context, snapshot){
                                    if (snapshot.hasData){
                                      return ListView(
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
                                                  contentPadding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                                  title: Text(doc.data()['subject_Name']),
                                                  //subtitle: Text(doc.id),
                                                  trailing: Text(doc.id),
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      HeroDialogRoute(
                                                        builder: (context) => Center(
                                                            child: EditSubjectPopUpBuilder(doc)
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Text("no data");
                                    }
                                  }
                              )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _setSubjectList() async{
    List <String> subjectList = await SubjectServices().getSubjectList();
    setState(() {
      this.subjectList = subjectList;
      this.finalSubjectList = subjectList;
    });
  }

  _searchOperation(String searchText){
    List<String> searchResult = [];
    this.finalSubjectList.forEach((subject) {
      if (subject.toLowerCase().contains(searchText.toLowerCase())){
        searchResult.add(subject);
      }
    });
    setState(() {
      if(searchResult.isEmpty){
        this.subjectList = ["empty"];
      } else {
        this.subjectList = searchResult;
      }
    });
  }
}
