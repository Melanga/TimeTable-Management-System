import 'package:flutter/material.dart';

class Subject{
  final String subjectName;
  final String hallName;
  final String startTime;
  final String endTime;

  Subject({
    this.subjectName,
    this.hallName,
    this.endTime,
    this.startTime
  });
}


List <Subject> subjects = [
  Subject(
    subjectName: 'Computer Science',
    hallName: 'E2 hall',
    startTime: '8.00 a.m.',
    endTime: '9.00 a.m.'
  ),
  Subject(
      subjectName: 'Networking',
      hallName: 'D2 hall',
      startTime: '9.00 a.m.',
      endTime: '11.00 a.m.'
  ),
  Subject(
      subjectName: 'English II',
      hallName: 'E1 hall',
      startTime: '11.00 a.m.',
      endTime: '12.00 p.m.'
  ),
  Subject(
      subjectName: 'Programming I (Theory)',
      hallName: 'E3 hall',
      startTime: '1.00 p.m.',
      endTime: '2.00 p.m.'
  ),
  Subject(
      subjectName: 'Programming I (Practical)',
      hallName: 'E3 hall',
      startTime: '4.00 p.m.',
      endTime: '6.00 p.m.'
  ),
];
