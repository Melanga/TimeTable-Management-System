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
        title: Text("Sign in"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Register', style: TextStyle(color: Colors.white),),
            onPressed: () {
              widget.toggleView();
            },
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
                      SizedBox(height: 20.0,),
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
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: TextButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
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
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
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
