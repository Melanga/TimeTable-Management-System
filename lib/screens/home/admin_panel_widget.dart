import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/addSubject/add_new_subject.dart';
import 'package:flutter_intelij/screens/home/admin_settings_drawer.dart';
import 'package:flutter_intelij/screens/widget/admin_subject_card_builder.dart';
import 'package:flutter_intelij/services/auth.dart';


class AdminPanelWidget extends StatefulWidget {
  AdminPanelWidget({Key key}) : super(key: key);

  @override
  _AdminPanelWidgetState createState() => _AdminPanelWidgetState();
}

class _AdminPanelWidgetState extends State<AdminPanelWidget> {
  TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthSevice _auth = AuthSevice();


  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
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
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => AddNewSubject()));
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
      drawer: adminSettingsDrawer,
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
            Align(
              alignment: Alignment(5.39, -0.95),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF438E99),
                    borderRadius: BorderRadius.circular(50),
                    shape: BoxShape.rectangle,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment(0, 0),
                          child:TextFormField(
                              controller: textController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Search here...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFE0F2F1),
                                  fontSize: 16,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFE0F2F1),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                    ],
                  ),
                ),
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
                              child: AdminSubjectCardBuilder().adminSubjectCardBuilder
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
}
