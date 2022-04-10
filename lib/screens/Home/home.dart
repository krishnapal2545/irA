import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ira/screens/Home/history.dart';
import 'package:ira/widgets/imgs.dart';
import 'package:ira/widgets/menu.dart';
import 'package:ira/widgets/sharebtn.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences prefs;

  const HomePage({Key? key, required this.prefs}) : super(key: key);
//
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('irA', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              CupertinoIcons.barcode_viewfinder,
              size: 40,
            ),
            tooltip: 'Open Last Food Details',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryPage(prefs: widget.prefs)));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: size.height * 0.30,
                  child: ScrollImages(),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                ShareButtons(prefs: widget.prefs),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: MenuButton(prefs: widget.prefs),
    );
  }
}
