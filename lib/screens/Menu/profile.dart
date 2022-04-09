import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ira/screens/Menu/editprofile.dart';
import 'package:ira/screens/Auth/login.dart';
import 'package:ira/screens/Menu/gift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final SharedPreferences prefs;

  const ProfilePage({Key? key, required this.prefs}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final db = FirebaseFirestore.instance;
  num? gift = -1;
  @override
  void initState() {
    super.initState();
    db
        .collection('users')
        .doc(widget.prefs.getString('uid'))
        .get()
        .then((value) {
      final data = value.data()!;
      setState(() {
        gift = data['gift'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String? name = widget.prefs.getString('name');
    String? gender = widget.prefs.getString('gender');
    String? type = widget.prefs.getString('type');
    String? address = widget.prefs.getString('address');
    String? profImg = widget.prefs.getString('profImg');
    String? phone = widget.prefs.getString('phone');
    // num? gift = widget.prefs.getInt('gift');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Profile"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPage(prefs: widget.prefs)));
                setState(() {});
              },
              icon: Icon(
                CupertinoIcons.pencil_outline,
              ))
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  radius: size.width * 0.25,
                  backgroundImage: profImg == 'none'
                      ? AssetImage('images/logo.png') as ImageProvider
                      : NetworkImage(profImg!),
                ),
                ListTile(
                  title: Text(name!),
                  leading: Icon(Icons.person, size: 30),
                ),
                ListTile(
                  title: Text(gender!),
                  leading: Icon(
                      gender == 'Male'
                          ? Icons.male_outlined
                          : gender == 'Female'
                              ? Icons.female_rounded
                              : Icons.call_split_rounded,
                      size: 30),
                ),
                ListTile(
                  title: Text(type!),
                  leading: Icon(Icons.task_alt, size: 30),
                ),
                ListTile(
                  title: Text(phone!),
                  leading: Icon(Icons.call, size: 30),
                ),
                ListTile(
                  title: Text(address!),
                  leading: Icon(Icons.location_city, size: 30),
                ),
                if (type == 'Helper')
                  if (gift == -1)
                    ListTile(
                      title: CircularProgressIndicator(),
                      leading: Icon(Icons.card_giftcard, size: 30),
                    ),
                if (type == 'Helper')
                  if (gift != -1)
                    ListTile(
                      title: Text("$gift"),
                      leading: Icon(Icons.card_giftcard, size: 30),
                      trailing: Icon(Icons.chevron_right_sharp, size: 30),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GiftPage(gift: gift))),
                    ),
                ListTile(
                  title: Text(" Logout !!!"),
                  leading: Icon(Icons.logout_rounded, size: 30),
                  onTap: () {
                    widget.prefs.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(prefs: widget.prefs)),
                        (route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
