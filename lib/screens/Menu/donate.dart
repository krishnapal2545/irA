import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class DonatePage extends StatelessWidget {
  final String message =
      '''Thank you for your generous gift to irA. We are thrilled to have your support. Through your donation we have been able to accomplish our goal and continue working towards feeding the needy people. You truly make the difference for us, and we are extremely grateful!''';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String payuri = "https://p.paytm.me/xCTH/rzagbli9";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Donate Money \$'), centerTitle: true),
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.6,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width * 0.1),
                    bottomRight: Radius.circular(size.width * 0.1))),
            child: ListView(
              children: [
                Column(
                  children: [
                    Image.asset('images/donate.png',
                        width: size.width, height: size.height * 0.4),
                    SizedBox(height: size.height * 0.09),
                    Link(
                      uri: Uri.parse(payuri),
                      target: LinkTarget.blank,
                      builder: (context, followlink) {
                        return Container(
                          width: size.width * 0.5,
                          height: size.height * 0.09,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: InkWell(
                              onTap: followlink,
                              child: Center(
                                child: Image(
                                    image: AssetImage('images/paytm.png')),
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
                  child: Container(
                    child: Text(message,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontStyle: FontStyle.italic)),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
