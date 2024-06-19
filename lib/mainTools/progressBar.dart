import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressBar extends StatelessWidget {
  final int highlightedButton;

  ProgressBar({required this.highlightedButton});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSemiCircle(curveUpwards: true),
          _buildSemiCircle(curveUpwards: false),
        ],
      ),
    );
  }

  Widget _buildSemiCircle({required bool curveUpwards}) {
    return Container(
      width: 400,
      height: 300,
      child: CustomPaint(
        painter: ButtonPainter(curveUpwards: curveUpwards),
        child: Stack(
          children: curveUpwards ? _buildButtonsUpwards() : _buildButtonsDownwards(),
        ),
      ),
    );
  }

  List<Widget> _buildButtonsUpwards() {
    return [
      _buildButton(0, 9 * math.pi / 8, Icons.fast_forward, Colors.purple),
      _buildButton(1, 11 * math.pi / 8, Icons.star, Colors.grey),
      _buildButton(2, 13 * math.pi / 8, Icons.star, Colors.grey),
      _buildButton(3, 15 * math.pi / 8, Icons.lock, Colors.grey),
    ];
  }

  List<Widget> _buildButtonsDownwards() {
    return [
      _buildButton(5, 17 * math.pi / 8, Icons.fast_forward, Colors.grey),
      _buildButton(6, 19 * math.pi / 8, Icons.star, Colors.grey),
      _buildButton(7, 21 * math.pi / 8, Icons.star, Colors.grey),
      _buildButton(8, 23 * math.pi / 8, Icons.lock, Colors.grey),
    ];
  }

  Widget _buildButton(int index, double angle, IconData icon, Color color) {
    final radius = 150.0;
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(x, y),
        child: ButtonWithIcon(
          icon: icon,
          color: highlightedButton == index ? Colors.amber : color,
          onPressed: () {},
        ),
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  ButtonWithIcon({required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, size: 30),
    );
  }
}

class ButtonPainter extends CustomPainter {
  final bool curveUpwards;

  ButtonPainter({required this.curveUpwards});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var path = Path();
    if (curveUpwards) {
      path.addArc(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 150), math.pi, math.pi);
    } else {
      path.addArc(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 150), 0, math.pi);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
