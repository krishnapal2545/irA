import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GiftPage extends StatefulWidget {
  final SharedPreferences prefs;

  const GiftPage({Key? key, required this.prefs}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  @override
  Widget build(BuildContext context) {
    num? gift = widget.prefs.getInt('gift');
    return Scaffold(
      appBar: AppBar(
        title: Text('$gift pts Cashback Points Balance'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(children: [
          Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text("Redeem Points", style: TextStyle(fontSize: 30)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Get exciting deals from 100+ Top Brands",
                          style: TextStyle(fontSize: 15)),
                    )
                  ])),
        ]),
      ),
    );
  }
}
