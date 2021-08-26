import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/subject_collection_crud.dart';


class AddNewSeminarPopUp extends StatefulWidget {
  const AddNewSeminarPopUp({Key key}) : super(key: key);

  @override
  _AddNewSeminarPopUpState createState() => _AddNewSeminarPopUpState();
}

class _AddNewSeminarPopUpState extends State<AddNewSeminarPopUp> {

  String heroId = "subjectPopUp";
  String seminarName;
  String seminarDescription = "Empty";
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserID();
  }
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroId,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Align(
          alignment: Alignment.center,
          child: Card(
            //color: Color(0xFF003640),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Seminar Name",
                        hintStyle: TextStyle(
                          color: Colors.black54
                        )
                      ),
                      onChanged: (inputValue)  {
                        this.seminarName = inputValue;
                        setState(() => {this.seminarName = inputValue});
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Enter Seminar Description",
                          hintStyle: TextStyle(
                              color: Colors.black54
                          )
                      ),
                      onChanged: (inputValue)  {
                        this.seminarDescription = inputValue;
                        setState(() => {this.seminarDescription = inputValue});
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.cyan),
                      ),
                      onPressed: () {
                        SubjectCRUDMethods crud = new SubjectCRUDMethods();
                        if(this.seminarName.isNotEmpty){
                          crud.addSeminarData(this.userId, this.seminarName, this.seminarDescription);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getUserID(){
    String userId = FirebaseAuth.instance.currentUser.uid;
    setState(() {
      this.userId = userId;
    });
  }
}
