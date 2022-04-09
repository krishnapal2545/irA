import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  @override
  _MenuButton2State createState() => _MenuButton2State();
}

class _MenuButton2State extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  bool isOpen = false;
  bool tp = false;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();

    _animationController.addListener(() {
      setState(() {});
    });
  }

  double radTodeg(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  double chooseDeg(int i) {
    double deg = i == 0
        ? 180
        : i == 1
            ? 225
            : i == 2
                ? 270
                : i == 3
                    ? 315
                    : 360;
    return deg;
  }

  Icon chooseIcon(int i) {
    Icon icon = i == 0
        ? (tp
            ? Icon(Icons.home, color: Colors.white)
            : Icon(Icons.cabin, color: Colors.white))
        : i == 1
            ? (tp
                ? Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                  )
                : Icon(Icons.person, color: Colors.white))
            : i == 2
                ? Icon(Icons.monetization_on, color: Colors.white)
                : i == 3
                    ? Icon(Icons.chat_rounded, color: Colors.white)
                    : Icon(Icons.info_outline_rounded, color: Colors.white);

    return icon;
  }

  Color chooseColor(int i) {
    Color color = i == 0
        ? Colors.red
        : i == 1
            ? Colors.blue
            : i == 2
                ? Colors.green
                : i == 3
                    ? Colors.pink
                    : Colors.deepOrange;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return SizedBox(
      // width: 200,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          for (int i = 0; i < 5; i++)
            Container(
              child: Transform.translate(
                offset: Offset.fromDirection(
                    _animation.value * radTodeg(chooseDeg(i)),
                    _animation.value * 100),
                child: CirCularButton(
                  width: 60.0,
                  height: 60.0,
                  color: chooseColor(i),
                  icon: chooseIcon(i),
                  onClick: () {
                    setState(() {
                      tp = true;
                    });
                  },
                ),
              ),
            ),
          CirCularButton(
            width: 60.0,
            height: 60.0,
            color: Colors.black,
            icon: Icon(isOpen ? Icons.cancel_outlined : Icons.apps_rounded,
                color: Colors.white),
            onClick: () {
              if (_animationController.isCompleted) {
                _animationController.reverse();
                setState(() {
                  isOpen = false;
                });
              } else {
                _animationController.forward();
                setState(() {
                  isOpen = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class CirCularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final VoidCallback onClick;
  const CirCularButton({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
