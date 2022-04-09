import 'package:flutter/material.dart';
import 'foodtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodHistory extends StatefulWidget {
  final String ftype;
  final SharedPreferences prefs;

  const FoodHistory({Key? key, required this.ftype, required this.prefs})
      : super(key: key);
  @override
  State<FoodHistory> createState() => _FoodHistoryState();
}

class _FoodHistoryState extends State<FoodHistory> {
  final db = FirebaseFirestore.instance;
  late var foodData = [];

  loadData() {
    db
        .collection('users')
        .doc(widget.prefs.getString('uid'))
        .get()
        .then((value) {
      var data = [];
      data = value[widget.ftype];
      foodData = data.reversed.toList();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget fooddata(BuildContext context, String foodID) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: db.collection(widget.ftype).doc(foodID).get(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError)
          return Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          );
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          DocumentSnapshot<Map<String, dynamic>> data = snapshot.data!;
          Map<String, dynamic> val = data.data()!;
          return FoodTile(val: val, history: true, prefs: widget.prefs);
        }

        return Center();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          if (foodData.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(child: CircularProgressIndicator())
              ],
            ),
          if (foodData.length > 0)
            for (int i = 0; i < foodData.length; i++)
              fooddata(context, foodData[i])
        ],
      ),
    );
  }
}
