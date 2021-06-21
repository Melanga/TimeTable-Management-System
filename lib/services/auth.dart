import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/models/app_user.dart';

class AuthSevice {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a custom user object
  AppUser _getCustomUserFromUser(User user){
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
        //.map((User user) => _getCustomUserFromUser(user));
        .map(_getCustomUserFromUser);
  }
  // sign in anonymously
  Future signInAnon() async{
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _getCustomUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return('Wrong password provided for that user.');
      }
    } catch(e) {
      return null;
    }
  }
  // sign in with email and password
  Future signInWithEmailAndPassword( String email, String password)async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _getCustomUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return('Wrong password provided for that user.');
      }
    } catch(e) {
      return null;
    }
  }
  // register with email and password
  Future registerWithEmailAndPassword( String email, String password)async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _getCustomUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    } catch (e) {
      return null;
    }
  }
  // sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}