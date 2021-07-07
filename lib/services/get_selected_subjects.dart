import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSelectedSubjects{

  Future<List<String>> getSelectedSubjectList()async{
    List<String> selectedSubjects = await _getSelectedSubjects();
    return selectedSubjects;
  }

  Future<List<String>> _getSelectedSubjects() async{
    final prefs = await SharedPreferences.getInstance();
    List <String>selectedSubjects = [];
    Map<String, dynamic> returnValues = json.decode(prefs.getString('selectedSubjects'));
    if(returnValues.isNotEmpty){
      returnValues.forEach((key, value) {
        if(value == true){
          selectedSubjects.add(key);
        }
      });
    }
    return selectedSubjects;
  }
}