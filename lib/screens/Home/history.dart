import 'package:flutter/material.dart';
import 'package:ira/widgets/historydata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatelessWidget {
  final SharedPreferences prefs;

  const HistoryPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('History'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'CookedFood',
                icon: Icon(Icons.food_bank),
              ),
              Tab(
                  text: 'UncookedFood',
                  icon: Icon(Icons.real_estate_agent_sharp)),
              Tab(
                  text: 'Fruits&Vegies',
                  icon: Icon(Icons.favorite_outline_sharp)),
              Tab(
                text: 'OtherThings',
                icon: Icon(Icons.cases_outlined),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              FoodHistory(ftype: 'CookedFood', prefs: prefs),
              FoodHistory(ftype: 'UncookedFood', prefs: prefs),
              FoodHistory(ftype: 'Fruits&Vegies', prefs: prefs),
              FoodHistory(ftype: 'OtherThings', prefs: prefs),
            ],
          ),
        ),
      ),
    );
  }
}
