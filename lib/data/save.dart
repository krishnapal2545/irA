import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ira/screens/Home/home.dart';

Future<void> saveUserData({
  required BuildContext context,
  required SharedPreferences prefs,
  required String uname,
  required String ugender,
  required String uType,
  required String uaddress,
  required String phoneNo,
  required File? uimage,
}) async {
  String profImg = 'none';
  // 'https://firebasestorage.googleapis.com/v0/b/iira-6fc2f.appspot.com/o/null%2Favtar.png?alt=media&token=518448af-a1e3-410d-842f-f420999e35cd';
  if (uimage != null) {
    profImg = await _saveImage(uimage, prefs);
  }
  final db = FirebaseFirestore.instance;
  await db.collection('users').doc(prefs.getString('uid')).set({
    'name': uname,
    'phone': phoneNo,
    'gender': ugender,
    'type': uType,
    'address': uaddress,
    'profileImg': profImg,
    'userID': prefs.getString('uid'),
    'gift': 0
  });
  prefs.setString('name', uname);
  prefs.setString('gender', ugender);
  prefs.setString('type', uType);
  prefs.setString('address', uaddress);
  prefs.setString('phone', phoneNo);
  prefs.setString('profImg', profImg);
  prefs.setBool('is_verified', true);
  prefs.setInt('gift', 0);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => HomePage(prefs: prefs),
    ),
  );
}

Future<String> _saveImage(File _image, dynamic prefs) async {
  String imageURL = await _uploadFile(_image, prefs);
  return imageURL;
}

Future<String> _uploadFile(File? _image, SharedPreferences prefs) async {
  String? addr = prefs.getString('mobile');
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('$addr/${basename(_image!.path)}');
  final uploadTask = ref.putFile(_image);
  await uploadTask.whenComplete(() => null);
  String returnURL = "";
  await ref.getDownloadURL().then((fileURL) => returnURL = fileURL);
  return returnURL;
}

Future<void> saveFoodData({
  required BuildContext context,
  required SharedPreferences prefs,
  required String fname,
  required String ftype,
  required int? fstate,
  required String fplace,
  required DateTime? ftime,
  required int? fnum,
  required File? fimage,
}) async {
  String foodImg = '';
  if (fimage != null) {
    foodImg = await _saveImage(fimage, prefs);
  }
  final db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> docRefs = db.collection(ftype).doc();
  await db.collection(ftype).doc(docRefs.id).set({
    'name': fname,
    'state': fstate,
    'type': ftype,
    'fnum': fnum,
    'place': fplace,
    'datetime': ftime,
    'foodImg': foodImg,
    'user': prefs.getString('uid'),
    'bookBy': 'none',
    'foodID': docRefs.id,
    'uptime': DateTime.now(),
    'cost': fnum! * 5,
    'booked': false,
    'transition': false,
  });
  await db.collection('users').doc(prefs.getString('uid')).set({
    ftype: FieldValue.arrayUnion([docRefs.id])
  }, SetOptions(merge: true));
}

Future<void> repFoodData({
  required Map<String, dynamic> val,
  required SharedPreferences prefs,
}) async {
  final db = FirebaseFirestore.instance;
  await db.collection('users').doc(prefs.getString('uid')).set({
    val['type']: FieldValue.arrayUnion([val['foodID']])
  }, SetOptions(merge: true));
  await db
      .collection(val['type'])
      .doc(val['foodID'])
      .update({'bookBy': prefs.getString('uid'), 'booked': true});
}

Future<void> deleFoodData(
  BuildContext context, {
  required Map<String, dynamic> val,
}) async {
  FirebaseFirestore.instance
      .collection(val['type'])
      .doc(val['foodID'])
      .delete()
      .then((value) {
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  });
}

Future<void> editUserData({
  required BuildContext context,
  required SharedPreferences prefs,
  required String uname,
  required String ugender,
  required String uType,
  required String uaddress,
  required String phoneNo,
  required File? uimage,
}) async {
  String profImg = prefs.getString('profImg')!;
  if (uimage != null) {
    profImg = await _saveImage(uimage, prefs);
  }
  final db = FirebaseFirestore.instance;
  await db.collection('users').doc(prefs.getString('uid')).update({
    'name': uname,
    'phone': phoneNo,
    'gender': ugender,
    'type': uType,
    'address': uaddress,
    'profileImg': profImg,
  });
  prefs.setString('name', uname);
  prefs.setString('gender', ugender);
  prefs.setString('type', uType);
  prefs.setString('address', uaddress);
  prefs.setString('phone', phoneNo);
  prefs.setString('profImg', profImg);
  prefs.setBool('is_verified', true);
  Navigator.pop(context);
}

Future<void> rewardUser(Map<String, dynamic> val) async {
  final db = FirebaseFirestore.instance;
  db.collection(val['type']).doc(val['foodID']).get().then((value) async {
    final data = value.data()!;
    if (!data['transition']) {
      await db
          .collection(val['type'])
          .doc(val['foodID'])
          .update({'transition': true});
      db.collection('users').doc(val['user']).get().then((value) {
        num count = value.data()!['gift'];
        count = count + val['cost'];
        db.collection('users').doc(val['user']).update({'gift': count});
      });
    }
  });
}
