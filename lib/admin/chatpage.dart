import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final SharedPreferences prefs;
  final String docID;
  final DocumentSnapshot<Map<String, dynamic>> userData;

  const ChatPage(
      {Key? key,
      required this.prefs,
      required this.docID,
      required this.userData})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final db = FirebaseFirestore.instance;
  late CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  late DocumentSnapshot<Map<String, dynamic>> userData;
  bool _isWritting = false;
  @override
  void initState() {
    super.initState();
    chatReference =
        db.collection("chats").doc(widget.docID).collection('messages');
    userData = widget.userData;
    db.collection("chats").doc(widget.docID).update({'time': DateTime.now()});
  }

  List<Widget> generateSenderLayout(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    DateTime time = (documentSnapshot['time'] as Timestamp).toDate();
    String ctime = DateFormat.yMMMd().add_jm().format(time);
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 5.0),
              padding: const EdgeInsets.all(10.0),
              width: 250,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentSnapshot['text'],
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ctime,
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.check, size: 13, color: Colors.white)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    DateTime time = (documentSnapshot['time'] as Timestamp).toDate();
    String ctime = DateFormat.yMMMd().add_jm().format(time);
    return (<Widget>[
      SizedBox(width: 8),
      Expanded(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                padding: const EdgeInsets.all(10.0),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentSnapshot['text'],
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(height: 3),
                    Text(
                      ctime,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ]),
      )
    ]);
  }

  generateMessages(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return snapshot.data!.docs
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                children: doc['sender_id'] != widget.prefs.getString('uid') &&
                        doc.exists
                    ? generateReceiverLayout(doc)
                    : generateSenderLayout(doc),
              ),
            ))
        .toList();
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'text': text,
      'sender_id': widget.prefs.getString('uid'),
      'sender_name': 'TeamirA',
      'time': DateTime.now(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isWritting ? () => _sendText(_textController.text) : null,
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: IconTheme(
          data: IconThemeData(
            color: _isWritting
                ? Color.fromARGB(255, 0, 0, 0)
                : Theme.of(context).disabledColor,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[100],
            ),
            child: new Row(
              children: <Widget>[
                SizedBox(width: 20),
                Flexible(
                  child: TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: _textController,
                    onChanged: (String messageText) {
                      setState(() {
                        _isWritting = messageText.length > 0;
                      });
                    },
                    onSubmitted: _sendText,
                    decoration:
                        InputDecoration.collapsed(hintText: "Send a message"),
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

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? backgroundImage = userData['profileImg'] != 'none'
        ? NetworkImage(userData['profileImg'])
        : AssetImage('images/avtar.png') as ImageProvider;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                SizedBox(width: 2),
                CircleAvatar(backgroundImage: backgroundImage, maxRadius: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userData['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        userData['phone'],
                        style: TextStyle(
                            color: Color.fromARGB(255, 248, 248, 248),
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/chat.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db
                  .collection("chats")
                  .doc(widget.docID)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData)
                  return Text("Please send us your query...");
                return Expanded(
                  child: new ListView(
                    reverse: true,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
            Divider(height: 1.0),
            Container(child: _buildTextComposer()),
            Builder(builder: (BuildContext context) {
              return Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }
}
