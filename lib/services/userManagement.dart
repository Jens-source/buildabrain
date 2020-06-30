import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class UserManagement {


  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'firstName': 0,
      'lastName': 0,
      'email': user.email,
      'uid': user.uid,
      'number': 0,
      'addressLine1' : 0,
      'addressLine2': 0,
      'district': 0,
      'province': 0,
      'zip': 0,
      'partnerUid': 0,
      'relationship': 0,
      'identity': 0,
    }).then((value) {}).catchError((e) {
      print(e);
    });
  }


  storeNewParent(user, context) {
    Firestore.instance.collection('/users').add({
      'firstName': 0,
      'lastName': 0,
      'email': user.email,
      'uid': user.uid,
      'birthday': 0,
      'number': 0,
      'identity': "Parent",
      'street': 0,
      'district': 0,
      'province': 0,
      'status' : 0
    }).then((value) {}).catchError((e) {
      print(e);
    });
  }



  storeNewLeader(user, context) {
    Firestore.instance.collection('/users').add({
      'firstName': 0,
      'lastName': 0,
      'email': user.email,
      'uid': user.uid,
      'number': 0,
      'identity': "Leader",
    }).then((value) {}).catchError((e) {
      print(e);
    });
  }


  static storeNewEntry(subject, clas, startDate, endDate, startTime, endTime, maxStudents) {
    Firestore.instance.collection('/schedule').add({
      'subject': subject,
      'class' : clas,
      'startDate': startDate,
      'endDate' : endDate,
      'startTime': startTime,
      'endTime': endTime,
      'timeStamp': DateTime.now(),
      'maxStudents': maxStudents
    }).catchError((e) {
      print(e);
    });
  }



  storeNewTeacher(user, context) async {
    File qr;
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
    );
    var response1;
    response1 = await http.get(uri.replace(queryParameters: <String, String>{

      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": user.uid,


    },), headers: {
      "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
      "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });


    print("response.body mother: ${response1.body}");








    File file = await DefaultCacheManager().getSingleFile(response1.body);
    var time = DateTime.now();
    StorageUploadTask task;
    print("File: ${file}");


    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('teacherQrCodes/${user.uid}.png');
    task = firebaseStorageRef.putFile(file);


    StorageTaskSnapshot snapshot = await task.onComplete;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("DownloadUrl: ${downloadUrl}");




  Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'number': 0,
      'district': 0,
      'province': 0,
      'about': 0,
      'identity': "Teacher",
      'photoUrl': 0,
      'lastName': 0,
      'qrCodeUrl': downloadUrl,
    }).then((value) {}).catchError((e) {
      print(e);
    });
  }


  static Future updateProfilePicture(picUrl) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;



    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'photoUrl': picUrl
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        });
      }).catchError((e) {
        print(e);
      });
    });
  }




  static Future updateProfilePictureStudent(picUrl, childID) async {
    var userInfo = new UserUpdateInfo();
          await Firestore.instance
              .document('/students/${childID}')

                    .updateData({
                  'photoUrl': picUrl
                }).then((val) {
                  print('Updated');

      }).catchError((e) {
        print(e);
      });

  }

  static Future updateFirstNameStudent(firstName, childID) async {
    var userInfo = new UserUpdateInfo();
    await Firestore.instance
        .document('/students/${childID}')

        .updateData({
      'firstName': firstName
    }).then((val) {
      print('Updated');

    }).catchError((e) {
      print(e);
    });

  }
  static Future updateLastNameStudent(lastName, childID) async {
    var userInfo = new UserUpdateInfo();
    await Firestore.instance
        .document('/students/${childID}')

        .updateData({
      'lastName': lastName
    }).then((val) {
      print('Updated');

    }).catchError((e) {
      print(e);
    });

  }


  static Future updateBirthdayStudent(birthday, childID) async {
    var userInfo = new UserUpdateInfo();
    await Firestore.instance
        .document('/students/${childID}')
        .updateData({
      'birthday': birthday
    }).then((val) {
      print('Updated');

    }).catchError((e) {
      print(e);
    });

  }



  static Future updateBrainstormPicture(id) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .collection('brainstorms')
              .add({
            'brainstormId': id,
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        });
      }).catchError((e) {
        print(e);
      });
    });
  }






  static Future updateStudentClass(qrCodeUrl, startTime, endTime, classType, startDate, nickName, firstName) async {
    var userInfo = new UserUpdateInfo();
    String studentId;

    List dates = [];






    await Firestore.instance.collection('schedule')
    .where('startDate', isEqualTo: startDate)
    .getDocuments()
    .then((val) {
      for (int i = 0; i < val.documents.length; i++) {
        if (DateTime.parse(startDate).isAfter(
            DateTime.parse(val.documents[i]['startDate'])) ||
            DateTime.parse(startDate).isAtSameMomentAs(
                DateTime.parse(val.documents[i]['startDate'])))
          if (DateTime.parse(startDate).isBefore(
              DateTime.parse(val.documents[i]['endDate'])) ||
              DateTime.parse(startDate).isAtSameMomentAs(
                  DateTime.parse(val.documents[i]['startDate'])))
            if (DateFormat('EEEE').format(DateTime.parse(startDate)) ==
                DateFormat("EEEE").format(
                    DateTime.parse(val.documents[i]['startDate']))) {
              dates.add(val.documents[i]);
            }
      }
      print(qrCodeUrl);
      Firestore.instance
          .collection('students')
          .where('qrCodeUrl', isEqualTo: qrCodeUrl)
          .getDocuments()
          .then((docs) {
        studentId = docs.documents[0].documentID;
        Firestore.instance.document('/students/${docs.documents[0].documentID}')
            .updateData({
          "classStartTime": startTime,
          'classEndTime': endTime,
          'classType': classType,
          'startDate': startDate,
        }).catchError((e) {
          print(e);
        });
      }).then((fef){

        for (int j = 0; j < dates.length; j++) {
          print("Typed in time: ${startTime}");
          print("Db time: ${val.documents[j]['startTime']}");

          if (startTime == val.documents[j]['startTime'])
            if (classType == val.documents[j]['class'])
              Firestore.instance.collection('schedule')

                  .document(val.documents[j].documentID)
                  .collection('students')
                  .where('firstName', isEqualTo: firstName)
                  .getDocuments()
                  .then((docs) {
                if (docs.documents.length == 0) {
                  Firestore.instance.collection('schedule')

                      .document(val.documents[j].documentID)
                      .collection('students')
                      .add({
                    'nickName': nickName,
                    "firstName": firstName,
                    'studentId': studentId,
                    'signedIn' : 0,
                  });
                }
              });
        }


      });



    });
  }

  static Future addChild(fatherUid,motherUid,  first, last, nick, birthday, gender, classType, classStartTime, classEndTime, classDay , docid) async {
    var userInfo = new UserUpdateInfo();





    String vol;
    String s;


    await Firestore.instance
        .collection('students')
          .add({
      'photoUrl' : 0,
      'qrCodeUrl': 0,
      'nickName': first,
        'firstName': 0,
        'lastName': last,
        'nickName': first,
        'birthday': birthday,
        'gender': gender,
        'fatherUid' : fatherUid,
      'motherUid': motherUid,
      'classType': classType,
      'daysPerWeek': 1,
      }).then((val) async {
        Firestore.instance.collection('students/${val.documentID}/schedules')
        .add({
          'classDay': classDay,
          'classStartTime': classStartTime,
          'classEndTime': classEndTime,

        });
        String docID = val.documentID;
        await Firestore.instance.collection('schedule/${docid}/students')
            .add({
          'firstName': first,
          'uid': docID,
        });
        File qr;
        var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
        );
        var response1;

        print("StudentID ${docID}");
        response1 = await http.get(uri.replace(queryParameters: <String, String>{

          "backcolor": "ffffff",
          "pixel": "9",
          "ecl": "L %7C M%7C Q %7C H",
          "forecolor": "000000",
          "type": "text %7C url %7C tel %7C sms %7C email",
          "text": docID,


        },), headers: {
          "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
          "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
        });


        print("response.body mother: ${response1.body}");








        File file = await DefaultCacheManager().getSingleFile(response1.body);
        var time = DateTime.now();
        StorageUploadTask task;
        print("File: ${file}");


        final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('studentQrCodes/${docID}.png');
        task = firebaseStorageRef.putFile(file);


        StorageTaskSnapshot snapshot = await task.onComplete;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        print("DownloadUrl: ${downloadUrl}");

        await Firestore.instance.document('students/${docID}')
        .updateData({
          'qrCodeUrl' : downloadUrl
        });







        print('Updated');

      }).catchError((e) {
        print(e);
      });

    return vol;
  }

  static Future updateProfilePictureFirstFather(picUrl) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    List <DocumentSnapshot> kids = new List<DocumentSnapshot>();


    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/students')
            .where('fatherUid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
             for(int i = 0; i < docs.documents.length; i++)
               {
                 if(docs.documents[i].data["qrCodeUrl"] == 0 )
                   {
                     Firestore.instance.document('/students/${docs.documents[i].documentID}')
                         .updateData({
                       'qrCodeUrl': picUrl
                     });
                   }
               }

        });
      }).catchError((e) {
        print(e);
      });
    });
  }


  static Future updateBirthday(birthday) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'birthday': birthday
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateProfilePictureFirstMother(picUrl) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    await FirebaseAuth.instance.currentUser().then((val) {
      print("Val,uid: ${val.uid}");
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('students')
            .where('motherUid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {

          for(int i = 0; i < docs.documents.length; i++)
          {
            if(docs.documents[i].data["qrCodeUrl"] == 0 )
            {

              Firestore.instance.document('/students/${docs.documents[i].documentID}')
                  .updateData({
                'qrCodeUrl': picUrl

              }).catchError((e){
              });
            }
          }
        });
      }).catchError((e) {
        print(e);
      });
    });
  }



  static Future updateTeacherQrCode(picUrl) async {
    var userInfo = new UserUpdateInfo();


    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'qrCodeUrl': picUrl
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  static Future updateAbout(about) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'about': about
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateFirstName(firstName) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'firstName': firstName
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateStatus(parent) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'status': parent
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateStudentGender(gender, docID) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .document('/students/${docID}')

            .updateData({
          "gender": gender

          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });

      });
    }
    );
  }

  static Future updateEntry(timeStamp, clas, endDate, startDate, endTime, startTime, subject) async {
    var userInfo = new UserUpdateInfo();
        Firestore.instance
            .collection('/schedule')
            .where('timeStamp', isEqualTo: timeStamp)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/schedule/${docs.documents[0].documentID}')
              .updateData({
            'subject': subject,
            'class' : clas,
            'startDate': startDate,
            'endDate' : endDate,
            'startTime': startTime,
            'endTime': endTime,

          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });

    }
    );
  }
  static Future deleteEntry(timeStamp, classDay) async {
    var userInfo = new UserUpdateInfo();




    await Firestore.instance
        .collection('schedule')
        .where('timeStamp', isEqualTo: timeStamp)
        .getDocuments()
        .then((docs) {
          Firestore.instance.collection('schedule/${docs.documents[0].documentID}/students')
          .getDocuments()
          .then((value) async{
            for(int i = 0; i < value.documents.length; i++){

              await Firestore.instance.document('students/${value.documents[i].data['uid']}')
              .updateData({
                'daysPerWeek': value.documents[i].data['daysPerWeek'] - 1
              });
              await Firestore.instance.collection('students/${value.documents[i].data['uid']}/schedules')
              .where('classDay', isEqualTo: classDay)
              .getDocuments()
              .then((value) async => {
                await Firestore.instance.document('students/${value.documents[i].data['uid']}/schedules/${value.documents[0].documentID}')
                .delete()
              });
            }
          }).then((vsf)async {

            await Firestore.instance.collection('/schedule/${docs.documents[0].documentID}/students').getDocuments().then((snapshot) {
              for (DocumentSnapshot doc in snapshot.documents) {
                doc.reference.delete();
              }}).then((efe){
               Firestore.instance.document('/schedule/${docs.documents[0].documentID}')
                  .delete()

                  .then((val) {
              print('Deleted');
              }).catchError((e) {
              print(e);
              });

              });
            });



    }
    );
  }

  static Future deleteUser(uid) async {
    var userInfo = new UserUpdateInfo();
    Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((docs) {
      Firestore.instance.document('/users/${docs.documents[0].documentID}')
          .delete()
          .then((val) {
        print('Deleted');
      }).catchError((e) {
        print(e);
      });
    }
    );
  }


  static Future updateLastName(lastName) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'lastName': lastName
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updatePhoneNumber(phoneNumber) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'phoneNumber': phoneNumber
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }



  static Future updateJobTitle(jobTitle) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'jobTitle': jobTitle
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateDesiredJobTitles(desiredJobTitle) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'desiredJobTitle': desiredJobTitle
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateStreet(street) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'street': street
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateDesiredSalary(desiredSalary) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'desiredSalary': desiredSalary
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateReloacatable(relocatable) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'relocatable': relocatable
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateEmail(email) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'email': email
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateDegree(degree) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'degree': degree
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateSchool(school) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'school': school
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateNickName(displayName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = displayName;


    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'displayName': displayName
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateFieldOfStudy(fieldOfStudy) async {
    var userInfo = new UserUpdateInfo();

    await
    FirebaseAuth.instance.currentUser()
        .
    then
      ((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('/users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'fieldOfStudy': fieldOfStudy
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }

  static Future updateCountries(country) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document(
              '/users/${docs.documents[0].documentID}')
              .collection('countries')
              .where('country', isEqualTo: country)
              .getDocuments()
              .then((vals) {
            print(vals.documents.length);
            if (vals.documents.length == 0) {
              Firestore.instance.document(
                  '/users/${docs.documents[0].documentID}')
                  .collection('countries')
                  .add({
                'country': country
              }).then((val) {
                print('Updated');
              }).catchError((e) {
                print(e);
              });
            }
          });
        });
      });
    });
  }


  static Future updateNumber(number) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'number': number
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );

    }
    );
  }



  static Future updateAssignedClass(teacherUid, classs) async {
    var userInfo = new UserUpdateInfo();

    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: teacherUid)
        .getDocuments()
        .then((docs) {
      Firestore.instance.document('/users/${docs.documents[0].documentID}')
          .updateData({
        'assignedClass': classs
      }).then((val) {
        print('Updated');
      }).catchError((e) {
        print(e);
      });
    }
    );
    }



  static Future updateAddress1(address1) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'addressLine1': address1
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateAddress2(address2) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'addressLine2': address2
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateDistrict(district) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'district': district
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateProvince(province) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'province': province
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updateZip(zip) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'zip': zip
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }


  static Future updatePartner(partnerUid) async {
    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((val) {
      val.updateProfile(userInfo).then((user) {
        Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: val.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
              .updateData({
            'partnerUid': partnerUid
          }).then((val) {
            print('Updated');
          }).catchError((e) {
            print(e);
          });
        }
        );
      });
    }
    );
  }
}


