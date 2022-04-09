import 'package:flutter/material.dart';

class GiftPage extends StatefulWidget {
  final num? gift;

  const GiftPage({Key? key, required this.gift}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  @override
  Widget build(BuildContext context) {
    num? gift = widget.gift;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$gift pts Cashback Points Balance'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(children: [
          Image.asset('images/gift.png'),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Redeem Points", style: TextStyle(fontSize: 30)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Get exciting deals from 100+ Top Brands",
                      style: TextStyle(fontSize: 15)),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Card(
                elevation: 4.0,
                child: Image.asset('images/gift_boat.png'),
              )),
              Expanded(
                  child: Card(
                elevation: 4.0,
                child: Image.asset('images/gift_boat2.png'),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Card(
                elevation: 4.0,
                child: Image.asset('images/gift_boat.png'),
              )),
              Expanded(
                  child: Card(
                elevation: 4.0,
                child: Image.asset('images/gift_boat.png'),
              )),
            ],
          ),
        ]),
      ),
    );
  }
}

// class _GiftCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Expanded(
//       child: Container(
//         child: Card(
//           child: Column(
//             children: [Image.asset('images/gift.png', width: 50)],
//           ),
//         ),
//       ),
//     );
//   }
// }
