


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ClassManagement {

  storeNewClass(subject, clas, date, startTime, endTime, teacher) {
    Firestore.instance.collection('/schedule').add({
      'timestamp': DateTime.now(),
      'subject': subject,
      'class': clas,
      'classDay': date,
      'startTime': startTime,
      'endTime': endTime,
      'timeStamp': DateTime.now(),
      "teacher": teacher
    }).catchError((e) {
      print(e);
    });
  }


  Future updateSchedule(day, classType, startTime, endTime, subject, teacher,
      docID) async {
    await Firestore.instance
        .collection('/schedule')
        .document(docID)
        .updateData({
      'subject': subject,
      'class': classType,
      'classDay': day,
      'startTime': startTime,
      'endTime': endTime,
      'timeStamp': DateTime.now(),
      "teacher": teacher
    }).catchError((e) {
      print(e);
    });
  }


  Future removeClass(docID)async {
    await Firestore.instance.collection('schedule')
        .document(docID)
        .delete();

  }
}