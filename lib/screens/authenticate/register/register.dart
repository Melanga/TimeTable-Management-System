import 'package:flutter/material.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/shared/constant.dart';
import 'package:flutter_intelij/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthSevice _auth = AuthSevice();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Set email and password variables
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF012329),
          centerTitle: true,
          title: Text("Register"),
          actions: <Widget>[
            TextButton.icon(
              label: Text('Go to Sign in', style: TextStyle(color: Colors.white),),
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
                            width: 100,
                            height: 100,
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

                        SizedBox(height: 20.0,),
                        TextFormField(
                          //decoration: textInputDecoration.copyWith(hintText: 'Email', hintStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                          //decoration: textInputDecoration.copyWith(hintText: 'Password', hintStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextButton(
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: ()async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                if (result.runtimeType == String) {
                                  setState(()  {
                                    error = result;
                                    loading = false;
                                  });
                                } else {
                                  setState(() {
                                    error = 'Enter a valid email address';
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
