import 'package:flutter/material.dart';

import 'circle_widget.dart';
import 'common_widgets/cw_container.dart';
import 'common_widgets/cw_elevated_button.dart';
import 'common_widgets/cw_text.dart';

enum ActionType { none, start, stop, done, fail }

class AnimationWidget extends StatefulWidget {
  final double width;
  const AnimationWidget({Key? key, required this.width}) : super(key: key);

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  ActionType _action = ActionType.none;
  final List<double> _diameters = [1, 0.6, 0.35];
  final List<int> _rotationStartDelays = [500, 300, 100];

  Widget actionButton(ActionType action, Color color) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: CWElevatedButton(
        onPressed: () {
          _action = action;
          setState(() {});
        },
        primary: color,
        bRadius: 4,
        child: CWText(action.name, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CWContainer(
          height: widget.width,
          width: widget.width,
          // color: Colors.amber,
          pad: [20],
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                CircleWidget(
                  diameter: _diameters[i] * widget.width,
                  rotationStartDelay: _rotationStartDelays[i],
                  action: _action,
                )
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            actionButton(ActionType.start, Colors.blue),
            actionButton(ActionType.stop, Colors.orange),
            actionButton(ActionType.done, Colors.green),
            actionButton(ActionType.fail, Colors.red),
          ],
        ),
      ],
    );
  }
}
