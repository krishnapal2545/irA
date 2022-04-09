import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ira/data/save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodInfo extends StatelessWidget {
  final SharedPreferences prefs;
  final Map<String, dynamic> val;
  final bool history;

  const FoodInfo(
      {Key? key, required this.prefs, required this.val, required this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        centerTitle: true,
        actions: [
          if (prefs.getString('uid') == val['user'])
            if (val['booked'])
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleFoodData(context, val: val),
              ),
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              _Itemimg(src: val['foodImg']),
              SizedBox(height: 10),
              _Iteminfo(val: val),
              SizedBox(height: 10),
              if (prefs.getString('uid') == val['user'])
                _Itemqr(encodeData: val['foodID']),
              if (prefs.getString('uid') != val['user'] && !val['transition'])
                _Itemotp(encodeData: val['foodID'], val: val),
              SizedBox(height: 10),
              if (prefs.getString('uid') != val['user'])
                _Itemuser(user: val['user']),
              SizedBox(height: 10),
            ],
          )
        ],
      )),
    );
  }
}

class _Itemimg extends StatelessWidget {
  final String src;
  const _Itemimg({
    Key? key,
    required this.src,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(src),
          ),
        )
      ],
    );
  }
}

class _Iteminfo extends StatelessWidget {
  final Map<String, dynamic> val;

  const _Iteminfo({Key? key, required this.val}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime extime = val['datetime'].toDate();
    String fextime = DateFormat.yMMMd().add_jm().format(extime);
    DateTime uptime = val['uptime'].toDate();
    String fuptime = DateFormat.yMMMd().add_jm().format(uptime);
    String title = val['name'];
    String place = val['place'];
    String fnum = '${val['fnum']}';
    String state = val['state'] == 1 ? 'Solid / Firm' : 'Liquid / Fluid';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
            title: Text(title),
            subtitle: Text('Title'),
            leading: Icon(CupertinoIcons.news)),
        ListTile(
            title: Text(place),
            subtitle: Text('Location of Item'),
            leading: Icon(CupertinoIcons.location)),
        ListTile(
            title: Text(fnum),
            subtitle: Text('Persons can Eat'),
            leading: Icon(CupertinoIcons.number)),
        ListTile(
            title: Text(state),
            subtitle: Text('State of item'),
            leading: Icon(CupertinoIcons.arrow_right_circle)),
        ListTile(
            title: Text(fextime),
            subtitle: Text('Expiry'),
            leading: Icon(CupertinoIcons.arrow_2_circlepath_circle)),
        ListTile(
            title: Text(fuptime),
            subtitle: Text('Uploaded on'),
            leading: Icon(CupertinoIcons.upload_circle)),
      ],
    );
  }
}

class _Itemqr extends StatelessWidget {
  final String encodeData;

  const _Itemqr({Key? key, required this.encodeData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<int> num = encodeData.codeUnits;
    // Text('${num[0]}${num[1]}${num[2]}${num[3]}'),
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
            child: Container(
              child: Center(
                  child: Text(
                '${num[0]}${num[1]}${num[2]}${num[3]}',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 30,
                ),
              )),
            )),
      ],
    );
  }
}

class _Itemotp extends StatefulWidget {
  final String encodeData;
  final Map<String, dynamic> val;

  _Itemotp({Key? key, required this.encodeData, required this.val})
      : super(key: key);

  @override
  State<_Itemotp> createState() => _ItemotpState();
}

class _ItemotpState extends State<_Itemotp> {
  final TextEditingController _textController = new TextEditingController();
  final db = FirebaseFirestore.instance;
  String _result = 'none';

  Future<Null> _sendText(String text) async {
    _textController.clear();
    List<int> num = widget.encodeData.codeUnits;
    String code = '${num[0]}${num[1]}${num[2]}${num[3]}';

    if (text == code) {
      rewardUser(widget.val);
      setState(() {
        _result = 'true';
      });
    } else {
      // print(code);
      setState(() {
        _result = 'false';
      });
    }
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: _result == 'true'
          ? Icon(Icons.check, color: Colors.green)
          : _result == 'false'
              ? Icon(Icons.cancel_presentation_sharp, color: Colors.red)
              : Icon(Icons.send),
      onPressed: () => _sendText(_textController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: IconTheme(
          data: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[100]),
            child: new Row(
              children: <Widget>[
                SizedBox(width: 20),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: _textController,
                    onChanged: (String messageText) {},
                    onSubmitted: _sendText,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter Food Unique Code"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: getDefaultSendButton(),
                ),
              ],
            ),
          )),
    );
  }
}

class _Itemuser extends StatefulWidget {
  final String user;
  _Itemuser({Key? key, required this.user}) : super(key: key);

  @override
  State<_Itemuser> createState() => _ItemuserState();
}

class _ItemuserState extends State<_Itemuser> {
  final db = FirebaseFirestore.instance;

  String name = '', phone = '', gender = '', src = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: db.collection('users').doc(widget.user).get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) return Text("Something went wrong");
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("User not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            DocumentSnapshot<Map<String, dynamic>> data = snapshot.data!;
            Map<String, dynamic> userData = data.data()!;
            name = userData['name'];
            phone = userData['phone'];
            gender = userData['gender'];
            src = userData['profileImg'];
            return Column(
              children: [
                ListTile(
                    title: Text(name),
                    leading:
                        src != '' ? Image.network(src) : Icon(Icons.person),
                    subtitle: Text(phone),
                    trailing: gender == 'Male'
                        ? Icon(Icons.male)
                        : gender == 'Female'
                            ? Icon(Icons.female)
                            : Icon(Icons.call_split_rounded)),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
