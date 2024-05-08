
import 'package:flutter/material.dart';

class MyElevatedButton extends StatefulWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Color hoverColor; // New parameter for hover color
  final VoidCallback? onPressed;
  final String text;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius,
    this.width = 260.0,
    this.height = 50.0,
    this.startColor = Colors.red,
    this.endColor = Colors.indigo,
    this.hoverColor = Colors.red, // Default kırmızı olsun dedim
  });

  @override
  _MyElevatedButtonState createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(20);
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHovered ? [widget.hoverColor, widget.hoverColor] : [widget.startColor, widget.endColor],
          ),
          borderRadius: borderRadius,
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}