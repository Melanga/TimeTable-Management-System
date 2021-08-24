import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {

  String emailAddress = "";
  final auth = FirebaseAuth.instance;
  String massageText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(color: Colors.black54),
                        //enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70))
                    ),
                    //style: TextStyle(color: Colors.white),
                    onChanged: (inputValue)  {
                      this.emailAddress = inputValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: TextButton(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await auth.sendPasswordResetEmail(email: this.emailAddress);
                      setState(() {
                        massageText = "An email has sent to $emailAddress";
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ))
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(massageText, style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
