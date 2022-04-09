import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ira/admin/chatpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  final SharedPreferences prefs;

  const ChatList({Key? key, required this.prefs}) : super(key: key);
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  userTab(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return snapshot.data!.docs.map<Widget>((doc) {
      String phone = doc["contact1"];
      String image = doc['profImg'];
      ImageProvider<Object>? backgroundImage = image != 'none'
          ? NetworkImage(image)
          : AssetImage('images/avtar.png') as ImageProvider;
      return InkWell(
        onTap: (() {
          db.collection("users").doc(doc.id).get().then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        prefs: widget.prefs, docID: doc.id, userData: value)));
          });
        }),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: ListTile(
            tileColor: Colors.black,
            leading: CircleAvatar(backgroundImage: backgroundImage, radius: 30),
            title: Text(
              doc["name"],
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            subtitle: Text(
              phone,
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              CupertinoIcons.arrowshape_turn_up_right_circle,
              color: Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }

  chatlist() {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: db.collection("chats").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Center(child: Text(" Loading User Queries.......")),
                    SizedBox(height: 50),
                    CircularProgressIndicator(),
                  ],
                );
              }
              return Expanded(
                  child: ListView(
                children: userTab(snapshot),
              ));
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return chatlist();
  }
}
