import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/models/app_user.dart';
import 'package:flutter_intelij/screens/authenticate/register/register.dart';
import 'package:flutter_intelij/screens/authenticate/register/signin.dart';
import 'package:flutter_intelij/screens/wrappers/login_wrapper.dart';
import 'package:flutter_intelij/services/auth.dart';
import 'package:flutter_intelij/shared/loading.dart';
import 'package:provider/provider.dart';

void main() async{
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
              title: 'TimeTable',
              theme: ThemeData(
                // Define the default brightness and colors.
                brightness: Brightness.light,
                primaryColor: Color(0xFF012329),
                accentColor: Color(0xFF003640),
                hintColor: Colors.white70,

                // Define the default font family.
                fontFamily: 'Poppins',

                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                /*textTheme: const TextTheme(
                  headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                  bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                ),*/
              ),
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
