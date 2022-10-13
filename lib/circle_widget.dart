import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'animation_widget.dart';

class CircleWidget extends StatefulWidget {
  final double diameter;
  final int rotationStartDelay;
  final ActionType action;
  const CircleWidget(
      {Key? key,
      required this.diameter,
      required this.rotationStartDelay,
      required this.action})
      : super(key: key);

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget>
    with TickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation rotateAnimation;
  late Function() forwardListener;

  late AnimationController resultColorController;
  late Animation resultAnimation;

  List<Color> gradientColors = [
    const Color.fromARGB(255, 78, 78, 78),
    Colors.white,
  ];
  final List<double> gradientStops = [0.10, 1.0];

  Map<ActionType, Color> resultColors = {
    ActionType.start: const Color.fromARGB(255, 78, 78, 78),
    ActionType.stop: const Color.fromARGB(255, 78, 78, 78),
    ActionType.done: const Color.fromARGB(255, 49, 202, 54),
    ActionType.fail: const Color.fromARGB(255, 240, 67, 37),
  };

  void initializeRotationAnimation() {
    rotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    rotationController.addListener(() => setState(() {}));
    rotateAnimation =
        Tween<double>(begin: pi / 2, end: pi * 2.5).animate(rotationController);
  }

  void initializeResultAnimation() {
    resultColorController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    resultColorController.addListener(() => setState(() {}));

    resultAnimation = ColorTween(begin: Colors.black, end: gradientColors[0])
        .animate(resultColorController);
  }

  void startInitialAnimation() {
    Future.delayed(Duration(milliseconds: widget.rotationStartDelay), () {
      resultColorController.forward();
    });
  }

  void initializeListener() {
    forwardListener = () async {
      if (rotationController.isCompleted) {
        //wait after one rotate, to start again
        await Future.delayed(const Duration(milliseconds: 500));
        rotationController.reset();
        rotationController.forward();
      }
    };
  }

  //*******
  @override
  void initState() {
    initializeRotationAnimation();
    initializeResultAnimation();
    startInitialAnimation();
    initializeListener();

    super.initState();
  }

  void showResultAnimation(ActionType colorKey) {
    Future.delayed(Duration(milliseconds: widget.rotationStartDelay + 800), () {
      resultAnimation =
          ColorTween(begin: resultAnimation.value, end: resultColors[colorKey])
              .animate(resultColorController);
      resultColorController.reset();
      resultColorController.forward();
    });
  }

  void startRotation() {
    Future.delayed(Duration(milliseconds: widget.rotationStartDelay), () {
      rotationController.reset();
      rotationController.forward();
      rotationController.removeListener(forwardListener);
      rotationController.addListener(forwardListener);
    });
  }

  void finishRotation() {
    Future.delayed(Duration(milliseconds: widget.rotationStartDelay), () {
      rotationController.removeListener(forwardListener);
    });
  }

  void handleActions() {
    try {
      if (widget.action == ActionType.start) {
        startRotation();
      } else {
        finishRotation();
      }
      showResultAnimation(widget.action);
    } catch (e) {
      print(e);
    }
  }

  //*******
  @override
  void didUpdateWidget(covariant CircleWidget oldWidget) {
    handleActions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    rotationController.dispose();
    resultColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotateAnimation.value,
      alignment: Alignment.center,
      child: Container(
        height: widget.diameter,
        width: widget.diameter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          color: Colors.black,
          gradient: SweepGradient(
            colors: [
              resultAnimation.value,
              Colors.white,
            ],
            stops: gradientStops,
          ),
        ),
      ),
    );
  }
}
