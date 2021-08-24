import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/authenticate/register/password_reset.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/shared/constant.dart';
import 'package:flutter_intelij/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthSevice _auth = AuthSevice();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password  = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012329),
        centerTitle: true,
        title: Text("Sign in"),
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Go to Register', style: TextStyle(color: Colors.white),),
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF003640),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.jpg'),
                              fit: BoxFit.contain
                          ),
                        ),
                      ),

                      Text('Timetable & Task Management System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'e-mail',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70))
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (val) {
                          return val.isEmpty ? 'Enter an email' : null;
                        },
                        onChanged: (inputValue)  {
                          setState(() => {email = inputValue});
                        },
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'password',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70))
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (val) {
                          return val.length < 6 ? 'Enter password at least six characters long' : null;
                        },
                        obscureText: true,
                        onChanged: (inputValue)  {
                          setState(() => {password = inputValue});
                        },
                      ),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordResetScreen(),
                            ),
                          ).then((value) {
                            setState(() {});
                          },
                          );
                        },
                        child: Text(
                          'forgot your password?',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 10, 70, 0),
                        child: TextButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                              if (result.runtimeType == String) {
                                setState(() {
                                  error = result;
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  error = 'Email or password is Wrong';
                                  loading = false;
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff05b5d3)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)
                            ))
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
