import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ira/admin/home.dart';
import '../Home/home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  final SharedPreferences prefs;

  const LoginPage({Key? key, required this.prefs}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo = " ";
  String smsOTP = '';
  String verificationId = '';
  String errorMessage = '';
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
  }

  Future<void> showLoading(BuildContext context, Size size) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.42, horizontal: size.width * 0.4),
            child: Container(child: CircularProgressIndicator()),
          );
        });
  }

  Future<void> verifyPhone() async {
    if (_formKey.currentState!.validate()) {
      try {
        final PhoneCodeSent smsOTPSent =
            (String verificationId, int? forceResendingToken) {
          this.verificationId = verificationId;
          smsOTPDialog(context).then((value) {});
        };
        await auth.verifyPhoneNumber(
            phoneNumber: this.phoneNo,
            codeAutoRetrievalTimeout: (String verId) {
              this.verificationId = verId;
            },
            codeSent: smsOTPSent,
            timeout: const Duration(seconds: 60),
            verificationCompleted:
                (PhoneAuthCredential phoneAuthCredential) async {},
            verificationFailed: (FirebaseAuthException e) {
              if (e.code == 'invalid-phone-number') {}
            });
      } catch (e) {
        print('error');
        print(e);
        handleError(e);
      }
    }
  }

  Future<void> smsOTPDialog(BuildContext context) async {
    Navigator.of(context).pop();
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP '),
            content: Container(
              height: 60,
              width: 50,
              child: Column(children: [
                TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      this.smsOTP = value;
                    }),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await auth
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: this.verificationId,
                          smsCode: this.smsOTP))
                      .catchError((onError) {
                    handleError(onError);
                  }).then((user) {
                    signIn();
                  });
                  showLoading(context, size);
                },
                child: Text('Verify'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      Navigator.of(context).pop();
      DocumentReference<Map<String, dynamic>> mobileRef = db
          .collection("mobiles")
          .doc(phoneNo.replaceAll(new RegExp(r'[^\w\s]+'), ''));
      await mobileRef.get().then((documentReference) {
        if (!documentReference.exists) {
          try {
            widget.prefs.setString('uid', documentReference.id);
            mobileRef.set({'uid': documentReference.id}).then(
                (documentReference) async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(
                        prefs: widget.prefs, phoneNo: this.phoneNo),
                  ),
                  (route) => false);
            }).catchError((e) {});
          } catch (e) {}
        } else if (documentReference["uid"] == 'admin') {
          widget.prefs.setString('uid', documentReference["uid"]);
          widget.prefs.setBool('is_verified', true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminPage(prefs: widget.prefs)),
              (route) => false);
        } else {
          widget.prefs.setString('uid', documentReference["uid"]);
          db
              .collection('users')
              .doc(documentReference['uid'])
              .get()
              .then((value) {
            if (!value.exists) {
              try {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(
                          prefs: widget.prefs, phoneNo: this.phoneNo),
                    ),
                    (route) => false);
              } catch (e) {}
            } else {
              getData(db, widget.prefs);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(prefs: widget.prefs),
                  ),
                  (route) => false);
            }
          });
        }
      }).catchError((e) {});
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> getData(dynamic db, SharedPreferences prefs) async {
    DocumentSnapshot data =
        await db.collection('users').doc(prefs.getString('uid')).get();
    if (data.exists) {
      Map<String, dynamic> userData = data.data() as Map<String, dynamic>;
      setState(() {
        prefs.setString('name', userData['name']);
        prefs.setString('gender', userData['gender']);
        prefs.setString('type', userData['type']);
        prefs.setString('address', userData['address']);
        prefs.setString('profImg', userData['profileImg']);
        prefs.setString('phone', userData['phone']);
        prefs.setInt('gift', userData['gift']);
        prefs.setBool('is_verified', true);
      });
    }
  }

  handleError(Object error) {
    switch (error) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {});
        break;
      default:
        setState(() {
          errorMessage = errorMessage;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Banner(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(size.width * 0.05, 0.0,
                        size.width * 0.18, size.height * 0.04),
                    child: SizedBox(
                      width: size.width * 0.7,
                      child: TextFormField(
                        style: TextStyle(fontSize: size.width * 0.04),
                        validator: ((value) {
                          if (value!.isEmpty)
                            return "Enter Valide Phone Number";
                          else if (value.length < 10)
                            return "Enter Valide Phone Number";
                          return null;
                        }),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(
                            CupertinoIcons.phone_circle_fill,
                            color: Colors.deepPurple,
                            size: size.width * 0.08,
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          labelText: 'Enter Phone Number',
                          prefix: Text('+91'),
                        ),
                        onChanged: (value) {
                          this.phoneNo = '+91$value';
                        },
                      ),
                    ),
                  ),
                  (errorMessage != ''
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()),
                  // SizedBox(
                  //   height: 15.0,
                  //   width: 30.0,
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(size.width * 0.2, 0.0,
                        size.width * 0.2, size.height * 0.05),
                    child: ElevatedButton(
                      onPressed: () async {
                        await verifyPhone();
                        showLoading(context, size);
                      },
                      child: Text('Verify'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        onSurface: Colors.grey,
                        minimumSize: Size(size.width * 0.5, size.height * 0.07),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'irA',
            style: TextStyle(
              fontSize: size.width * 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            "images/login.png",
            width: size.width,
            height: size.height * 0.5,
          )
        ],
      ),
    );
  }
}
