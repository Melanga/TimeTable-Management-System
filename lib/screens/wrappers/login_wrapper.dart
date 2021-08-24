import 'package:flutter/material.dart';
import 'package:flutter_intelij/models/app_user.dart';
import 'package:flutter_intelij/screens/authenticate/authenticate.dart';
import 'package:flutter_intelij/screens/wrappers/home_page_wrapper.dart';
import 'package:flutter_intelij/screens/wrappers/verify_screen.dart';
import 'package:provider/provider.dart';

class LoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // access data from provider
    final user = Provider.of<AppUser>(context);
    //  return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return VerifyScreen();
    }
  }
}
