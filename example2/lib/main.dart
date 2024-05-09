import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    //point where we want to start point and close point
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        path.moveTo(0, 0); // start from which point
        offset = Offset(0, size.height); // ending point
        clockwise = true; // path direction
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    //to comeback to the end point to the initial state
    path.close();
    return path;
  }
}

//custom clipper
class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0.0, end: -pi/2).animate(
      // CurvedAnimation(parent: _controller, curve: Curves.bounceIn),
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
      );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            // transform: Matrix4.identity()..rotateZ(_animation.value),
            transform: Matrix4.identity()..rotateZ(_animation.value), 
            child: SafeArea(
              //here we use the concept of the clippers in animations
              // clipper help to extract the quadrilateral as we want  from a widget and apply it on that widget
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipPath(
                    clipper: const HalfCircleClipper(side: CircleSide.left),
                      child: Container(
                          height: 100, width: 100, color: Colors.blue)),
                  ClipPath(
                    clipper: const HalfCircleClipper(side: CircleSide.right),
                      child: Container(
                          height: 100, width: 100, color: Colors.amber)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
