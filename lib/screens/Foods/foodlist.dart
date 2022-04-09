import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ira/widgets/foodtile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodList extends StatefulWidget {
  final String ftype;
  final SharedPreferences prefs;

  FoodList({
    Key? key,
    required this.ftype,
    required this.prefs,
  }) : super(key: key);

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];
  bool expiry = false, today = false, htol = false;

  loadData() async {
    if (expiry && today && htol) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('datetime', descending: expiry)
          .orderBy('uptime', descending: today)
          .orderBy('fnum', descending: htol)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (expiry && today) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('datetime', descending: expiry)
          .orderBy('uptime', descending: today)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (expiry && htol) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('datetime', descending: expiry)
          .orderBy('fnum', descending: htol)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (today && htol) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('uptime', descending: today)
          .orderBy('fnum', descending: htol)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (expiry) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('datetime', descending: expiry)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (today) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('uptime', descending: today)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else if (htol) {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .orderBy('fnum', descending: htol)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    } else {
      await db
          .collection(widget.ftype)
          .where('booked', isEqualTo: false)
          .snapshots()
          .forEach((element) {
        data = element.docs;
        setState(() {});
      }).onError((error, stackTrace) => {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  Widget foodTile(
      BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {
    Map<String, dynamic> val = data.data();
    return FoodTile(val: val, history: false, prefs: widget.prefs);
  }

  Widget filter(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Center(
              child: Text(
                'Change the data According to your requirement',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          ListTile(
            title: const Text('Expiry Today'),
            subtitle: const Text('In descendng order'),
            leading: Icon(
              CupertinoIcons.alarm_fill,
              color: expiry ? Colors.deepPurple : Colors.black,
              size: 30,
            ),
            trailing: Switch(
              value: expiry,
              onChanged: (value) {
                setState(() {
                  if (expiry)
                    expiry = false;
                  else
                    expiry = true;
                });
              },
            ),
            onTap: () {
              setState(() {
                if (expiry)
                  expiry = false;
                else
                  expiry = true;
              });
            },
          ),
          ListTile(
            title: const Text('Uploaded Today'),
            subtitle: const Text('In descendng order'),
            leading: Icon(
              CupertinoIcons.upload_circle_fill,
              color: today ? Colors.deepPurple : Colors.black,
              size: 30,
            ),
            trailing: Switch(
                value: today,
                onChanged: (value) {
                  setState(() {
                    if (today)
                      today = false;
                    else
                      today = true;
                  });
                }),
            onTap: () {
              setState(() {
                if (today)
                  today = false;
                else
                  today = true;
              });
            },
          ),
          ListTile(
            title: const Text('Higher to Low People'),
            subtitle: const Text('In descendng order'),
            leading: Icon(
              CupertinoIcons.arrow_up_arrow_down_circle_fill,
              color: htol ? Colors.deepPurple : Colors.black,
              size: 30,
            ),
            trailing: Switch(
                value: htol,
                onChanged: (value) {
                  setState(() {
                    if (htol)
                      htol = false;
                    else
                      htol = true;
                  });
                }),
            onTap: () {
              setState(() {
                if (htol)
                  htol = false;
                else
                  htol = true;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ftype),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: Icon(
                          CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                          size: 35));
                },
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: ListView(children: [
          if (data.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(child: CircularProgressIndicator())
              ],
            ),
          if (data.length > 0)
            for (int i = 0; i < data.length; i++) foodTile(context, data[i])
        ])),
        endDrawer: filter(context));
  }
}
