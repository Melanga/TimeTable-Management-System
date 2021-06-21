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
          title: Text("Sign in"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('Sign in', style: TextStyle(color: Colors.white),),
              onPressed: () {
                widget.toggleView();
              },
            )
          ],
        ),
        body: Container(
          color: Color(0xFF003640),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) {
                    return val.isEmpty ? 'Enter an email' : null;
                  },
                  onChanged: (inputValue)  {
                    setState(() => {email = inputValue});
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) {
                    return val.length < 6 ? 'Enter password at least six characters long' : null;
                  },
                  obscureText: true,
                  onChanged: (inputValue)  {
                    setState(() => {password = inputValue});
                  },
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
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
                  elevation: 0.0,
                  color: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                SizedBox(height: 20.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        )
    );
  }
}
