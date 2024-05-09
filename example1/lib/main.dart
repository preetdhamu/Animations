import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData.dark(),
    );
  }
}

//animation controller is the values between 0 and 1 at the based of 3 seconds

// 0.0 = 0 degree
// 0.5 = 180 degree
// 1.0 = 360 degree

//animation objects

//we need here statefull because we  are changing value in our animation object and worry about the dispose of animation controller .

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, //singletickerproviderstatemixin
      duration: const Duration(seconds: 2),
    );

    //animation is always works with the controller object
    //tween looks  like between
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    //key role is transform in every animation
    //for smoothing in the effect we need to repeat the process
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

            // topLeft , topCenter , topRight
            //  |------------|
            //  |            |                            // center.Left center     center.Right
            //  |------------|
            // bottomLeft , bottonCenter , bottomRight

            // Alignment.left
            // Alignment.Topleft

            //transforms the widget according to the given

            // transform: Matrix4.identity()..rotateZ(0.2),
            transform: Matrix4.identity()..rotateZ(_animation.value),
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: const Text(
                  "Hello",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
