import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class StudentManagement {
  Future storeNewStudent(nick, gender, DocumentSnapshot schedule) async {
    String vol;
    String s;
    await Firestore.instance.collection('students').add({
      'photoUrl': 0,
      'active': 0,
      'coursesComplete': 0,
      'qrCodeUrl': 0,
      'firstName': 0,
      'lastName': 0,
      'nickName': nick,
      'birthday': 0,
      'gender': gender,
      'fatherUid': 0,
      'motherUid': 0,
      'classType': 0,
      'daysPerWeek': 1,
    }).then((val) async {
      Firestore.instance
          .collection('students/${val.documentID}/schedules')
          .add({
        'classDay': schedule['classDay'],
        'classStartTime': schedule['startTime'],
        'classEndTime': schedule['endTime'],
      });
      String docID = val.documentID;
      await Firestore.instance
          .collection('schedule/${schedule.documentID}/students')
          .add({
        'firstName': nick,
        'uid': docID,
      });
      File qr;
      var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api"));
      var response1;

      print("StudentID ${docID}");
      response1 = await http.get(
          uri.replace(
            queryParameters: <String, String>{
              "backcolor": "ffffff",
              "pixel": "9",
              "ecl": "L %7C M%7C Q %7C H",
              "forecolor": "000000",
              "type": "text %7C url %7C tel %7C sms %7C email",
              "text": docID,
            },
          ),
          headers: {
            "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
            "x-rapidapi-key":
                "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
          });

      File file = await DefaultCacheManager().getSingleFile(response1.body);
      var time = DateTime.now();
      StorageUploadTask task;

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('studentQrCodes/${docID}.png');
      task = firebaseStorageRef.putFile(file);

      StorageTaskSnapshot snapshot = await task.onComplete;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("DownloadUrl: ${downloadUrl}");

      await Firestore.instance
          .document('students/${docID}')
          .updateData({'qrCodeUrl': downloadUrl});
      print('Updated');
    }).catchError((e) {
      print(e);
    });

    return vol;
  }

  Future removeStudent(studentDocID, schedule, studentUid) async {
    //Remove from schedule

    Firestore.instance
        .document('schedule/${schedule.documentID}/students/$studentDocID')
        .delete();

    Firestore.instance
        .collection('students')
        .document(studentUid)
        .get()
        .then((volue) {
      int daysPerWeek = volue['daysPerWeek'];

      Firestore.instance
          .collection('students')
          .document(studentUid)
          .updateData({
        "daysPerWeek": daysPerWeek - 1,
      });
    });

    //Remove from students
    await Firestore.instance
        .collection('students/$studentUid/schedules')
        .where('classDay', isEqualTo: schedule.data['classDay'])
        .getDocuments()
        .then((value) {
      Firestore.instance
          .collection('students/$studentUid/schedules')
          .document(value.documents[0].documentID)
          .delete();
    });
  }
}
