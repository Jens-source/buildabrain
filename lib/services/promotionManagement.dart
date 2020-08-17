import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class PromotionManagement {


  storePromotion( eventPhoto, name, startDate, endDate, startTime, endTime, host, description, locationUrl,
      material, dressCode) {
    Firestore.instance.collection('promotions').add({
      "photoUrl": eventPhoto,
      "name": name,
      "startDate": startDate,
      "endDate": endDate,
      "startTime": startTime,
      "endTime": endTime,
      "host": host,
      "description": description,
      "locationUrl": locationUrl,
      "material": material,
      "dressCode": dressCode,
      "interested": 0
    }).then((value) {

    }).catchError((e) {
      print(e);
    });
  }
}