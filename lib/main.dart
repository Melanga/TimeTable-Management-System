import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/models/app_user.dart';
import 'package:flutter_intelij/screens/authenticate/register/register.dart';
import 'package:flutter_intelij/screens/authenticate/register/signin.dart';
import 'package:flutter_intelij/screens/wrappers/login_wrapper.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/shared/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }
          // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<AppUser>.value(
            value: AuthSevice().user,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              //home: LoginWrapper(),
              routes: {
                '/': (context) => LoginWrapper(),
                '/register': (context) => Register()
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}
