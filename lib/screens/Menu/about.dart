import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String _message = '''
      irA is a sanskrit word means “FOOD”. irA can use to help hunger by earning some reward.In irA user can upload there extra meal so that other hungery needy people can get it and that user will win some reward too.
 ''';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About irA'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Text("Our Purpose",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
              Text("Empowering people to end global hunger",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'images/hungppl.png',
                  width: size.width * 0.8,
                ),
              ),
              SizedBox(height: 20),
              Text("Our Values",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
              Text("A few important things we live by",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Container(
                width: size.width * 0.9,
                height: 200,
                child: Card(
                  elevation: 4.0,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          SizedBox(width: size.width * 0.06),
                          Icon(CupertinoIcons.heart_fill,
                              color: Colors.red, size: 60),
                          SizedBox(width: size.width * 0.01),
                          Text("Open and honest",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 30, 40, 10),
                        child: Text(
                          "We want you to know how your donation is used and the impact you’re having around the world.",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: size.width * 0.9,
                height: 200,
                child: Card(
                  elevation: 4.0,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          SizedBox(width: size.width * 0.06),
                          Icon(CupertinoIcons.hand_thumbsup_fill,
                              color: Colors.blueAccent, size: 60),
                          SizedBox(width: size.width * 0.01),
                          Text("We’re in it together",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 30, 40, 10),
                        child: Text(
                          "We want fighting hunger to be inclusive so that anyone, anywhere, can share the meal.",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Our Team",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "BTech TY EXTC Student in K J Somaiya College Of Engineering",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17)),
              ),
              SizedBox(height: 20),
              _TeamImages()
            ],
          )
        ],
      )),
    );
  }
}

class _TeamImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child:
                              Image.asset('images/maleAvtar.png', width: 200),
                        ),
                        SizedBox(height: 10),
                        Text("Krishnakumar Pal"),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child:
                              Image.asset('images/maleAvtar.png', width: 200),
                        ),
                        SizedBox(height: 10),
                        Text("Amit Patil"),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child:
                              Image.asset('images/femalAvtar.png', width: 200),
                        ),
                        SizedBox(height: 10),
                        Text("Riya Thakkar"),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child:
                              Image.asset('images/maleAvtar.png', width: 200),
                        ),
                        SizedBox(height: 10),
                        Text("Abhay"),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
