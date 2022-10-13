import 'package:flutter/material.dart';

class CWContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color color;
  final Gradient? gradient;
  final Color brColor;
  final BoxShape? shape;
  final BlendMode? blendMode;
  final Matrix4? transform;
  final AlignmentGeometry? trAlignment;

  /// topLeft , topRight , bottomRight , bottomLeft
  final List<double> br;
  final double brAll;
  final double brWidth;
  final AlignmentGeometry? al;
  final List<BoxShadow>? boxShadow;

  /// top , right , bottom , left[\n]
  /// top&bottom , right&left
  /// all sides
  final List<double> mar;

  /// top , right , bottom , left
  final List<double> pad;

  const CWContainer({
    Key? key,
    this.child = const Text(""),
    this.height,
    this.width,
    this.color = Colors.transparent,
    this.gradient,
    this.brColor = Colors.transparent,
    this.blendMode,
    this.transform,
    this.trAlignment,
    this.br = const [0, 0, 0, 0],
    this.brAll = -1,
    this.brWidth = 1,
    this.al,
    this.boxShadow,
    this.mar = const [0, 0, 0, 0],
    this.pad = const [0, 0, 0, 0],
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> borders = br;
    if (brAll != -1) {
      borders = [brAll, brAll, brAll, brAll];
    }
    if (mar.length == 1) {
      mar.addAll([mar[0], mar[0], mar[0]]);
    }
    if (mar.length == 2) {
      double vertical = mar[0];
      double hor = mar[1];
      mar.clear();
      mar.addAll([vertical, hor, vertical, hor]);
    }
    // final List<double> pad = [];
    if (pad.length == 1) {
      pad.addAll([pad[0], pad[0], pad[0]]);
    }
    if (pad.length == 2) {
      double vertical = pad[0];
      double hor = pad[1];
      pad.clear();
      pad.addAll([vertical, hor, vertical, hor]);
    }
    return Container(
      height: height,
      width: width,
      alignment: al,
      // clipBehavior: Clip.hardEdge,
      transform: transform,
      transformAlignment: trAlignment,
      margin: EdgeInsets.only(
          top: mar[0], right: mar[1], bottom: mar[2], left: mar[3]),
      padding: EdgeInsets.only(
          top: pad[0], right: pad[1], bottom: pad[2], left: pad[3]),
      decoration: BoxDecoration(
        backgroundBlendMode: blendMode,
        color: color,
        gradient: gradient,
        shape: shape ?? BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borders[0]),
          topRight: Radius.circular(borders[1]),
          bottomRight: Radius.circular(borders[2]),
          bottomLeft: Radius.circular(borders[3]),
        ),
        border: Border.all(color: brColor, width: brWidth),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
