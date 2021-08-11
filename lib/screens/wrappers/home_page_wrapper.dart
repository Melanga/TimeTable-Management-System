import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/home/admin_panel_widget.dart';
import 'package:flutter_intelij/screens/home/home_screen.dart';

// either return QR Code or Scanner using the data of scan option.

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List <String> adminUsers = ["csiadmin@example.com"];
    bool admin = false;
    final userEmail = FirebaseAuth.instance.currentUser.email;
    if (adminUsers.contains(userEmail)) {
      admin = true;
    } else {
      admin = false;
    }

    if (admin == true) {
      return AdminPanelWidget();
    }
    else{
      return HomeScreen();
    }
  }
}
