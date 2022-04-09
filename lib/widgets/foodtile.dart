import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:ira/data/save.dart';
import 'package:ira/screens/Foods/foodinfo.dart';

class FoodTile extends StatefulWidget {
  final Map<String, dynamic> val;
  final bool history;
  final SharedPreferences prefs;

  const FoodTile(
      {Key? key, required this.val, required this.history, required this.prefs})
      : super(key: key);

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  _showFoodinfo(BuildContext context) async {
    if (widget.history) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodInfo(
                  prefs: widget.prefs,
                  val: widget.val,
                  history: widget.history)));
    } else {
      await repFoodData(val: widget.val, prefs: widget.prefs);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Item is Booked'),
          content: const Text(
              'For more information of item go to your History Page!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime extime = widget.val['datetime'].toDate();
    String fextime = DateFormat.yMMMd().add_jm().format(extime);
    DateTime uptime = widget.val['uptime'].toDate();
    String fuptime = DateFormat.yMMMd().add_jm().format(uptime);
    String address = widget.val['place'];

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(10.0),
                width: size.width / 3,
                child: Image.network(widget.val['foodImg'])),
            Container(
              child: Flexible(
                  child: Column(children: [
                ListTile(
                  title: _Header(title: widget.val['name']),
                  subtitle: _Descrip(
                    uptime: fuptime,
                    extime: fextime,
                    ppl: widget.val['fnum'],
                    phs: widget.val['state'],
                    address: address,
                  ),
                ),
                if (!widget.history)
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ButtonBar(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _PriceTag(),
                        )
                      ],
                    ),
                  ])
              ])),
            ),
          ],
        ),
        onTap: () => _showFoodinfo(context),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: width / 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Descrip extends StatelessWidget {
  final String uptime, extime, address;
  final num ppl, phs;

  const _Descrip(
      {Key? key,
      required this.uptime,
      required this.extime,
      required this.ppl,
      required this.phs,
      required this.address})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String phase = phs == 1 ? 'Solide' : 'Liquide';
    String mess =
        '''\nPhase : $phase\nPeople: $ppl\nAddress : $address\nExpiry  : $extime \nPosted: $uptime''';
    return Text(
      mess,
      style: TextStyle(fontSize: width / 25),
    );
  }
}

class _PriceTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        splashColor: Colors.white,
        child: Container(
          width: width / 5,
          height: height / 20,
          alignment: Alignment.center,
          child: Text(
            "Book",
            style: TextStyle(
                color: Colors.white,
                fontSize: width / 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
