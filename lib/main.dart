import 'package:flutter/material.dart';
import 'package:ira/admin/home.dart';
// import 'package:ira/screens/Intro/first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Home/home.dart';
import 'screens/Auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SharedPreferences.getInstance().then(
    (prefs) {
      runApp(MyApp(prefs: prefs));
    },
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'irA',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: _checkUser(),
    );
  }

  _checkUser() {
    if (prefs.getBool('is_verified') != null) {
      if (prefs.getBool('is_verified')!) {
        if (prefs.getString('uid') == 'admin') return AdminPage(prefs: prefs);
        return HomePage(prefs: prefs);
      }
    }
    return LoginPage(prefs: prefs);
  }
}
