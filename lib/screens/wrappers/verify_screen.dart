import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/wrappers/login_wrapper.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/shared/loading.dart';

import 'home_page_wrapper.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  final auth = FirebaseAuth.instance;
  String emailVerification = "going on";
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    if(!user.emailVerified){
      user.sendEmailVerification();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(emailVerification == "verified"){
      return HomePageWrapper();
    } else if((emailVerification == "not verified")) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Verify your email"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Color(0xFF003640),
                child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 15, 20),
                          child: Text(
                            'An email has been sent to \n- ${user.email}. \nPlease verify your email. '
                            'Make sure you have provided your University email Address. '
                            'Otherwise you will not be able to access the Time Table',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                        ),
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10 ,3, 10, 3),
                            child: Text(
                              'Change Your Email',
                              style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: ()async {
                            AuthSevice auth = new AuthSevice();
                            auth.signOut();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff05b5d3)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                              ))
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ],
        )
      );
    } else {
      return Loading();
    }
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified){
      timer.cancel();
      setState(() {
        emailVerification = "verified";
      });
    } else {
      setState(() {
        emailVerification = "not verified";
      });
    }
  }
}
