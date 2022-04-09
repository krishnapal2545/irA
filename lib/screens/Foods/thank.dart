import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ThankYouPage extends StatelessWidget {
  final String encodeData;

  const ThankYouPage({Key? key, required this.encodeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
          child: Column(
            children: [
              Center(
                child: Container(
                    child: Column(children: [
                  Text("Thank You",
                      style:
                          TextStyle(fontSize: 40, fontStyle: FontStyle.italic)),
                  Text("Members will reach soon for food",
                      style: TextStyle(fontSize: 20))
                ])),
              ),
              Center(
                child: Container(
                  child: Column(children: [
                    Image.asset('images/namaste.gif'),
                  ]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.1),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "This QR Code is for Our Member to Scan",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    QrImage(
                        data: encodeData,
                        version: QrVersions.auto,
                        size: size.width * 0.4,
                        backgroundColor: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _BackButton(),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(60)),
      width: size.width * 0.18,
      height: size.height * 0.1,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        enableFeedback: true,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }
}
