import 'package:flutter/material.dart';
import 'package:ira/widgets/shareform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePage extends StatelessWidget {
  final String ftype;
  final SharedPreferences prefs;
  const SharePage({Key? key, required this.ftype, required this.prefs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Form for $ftype'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [ShareForm(ftype: ftype, prefs: prefs)],
          )
        ],
      )),
    );
  }
}
