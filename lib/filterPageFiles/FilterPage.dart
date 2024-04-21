import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilterState();
  }
}


class _FilterState extends State<FilterPage>
    with TickerProviderStateMixin {
    late AnimationController controller;
    late Animation<double> _animation10;
    late Animation<double> _animation11;
    late Animation<double> _animation12;
    late Animation<double> _animation13;



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
              children: [
                Container(
                  width: 260,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: ClipRRect( // Clip the image to match the container's rounded corners
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/b/ba/Kokosnuss-Coconut.jpg', 
                          width: 260,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.75),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              "Test",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                MyElevatedButton(
                  height: 50,
                  width: 260,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(20),
                  startColor: Colors.red,
                  endColor: Colors.red.withOpacity(0.75),
                  hoverColor: Colors.blue,
                  child: Text(
                    "A1",
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
                const SizedBox(height: 20),
                MyElevatedButton(
                  height: 50,
                  width: 260,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(20),
                  startColor: Colors.red,
                  endColor: Colors.red.withOpacity(0.75),
                  hoverColor: Colors.blue,
                  child: Text(
                    "A2",
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
                
                const SizedBox(height: 40),
                MyElevatedButton(
                    height: 50,
                    width: 260,
                    onPressed: () {},
                    borderRadius: BorderRadius.circular(20),
                    startColor: Colors.red,
                    endColor: Colors.red.withOpacity(0.75),
                    hoverColor: Colors.yellow,
                    child: Text(
                      "B1",
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
                const SizedBox(height: 20),
                MyElevatedButton(
                  height: 50,
                  width: 260,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(20),
                  startColor: Colors.red,
                  endColor: Colors.red.withOpacity(0.75),
                  hoverColor: Colors.yellow,
                  child: Text(
                    "B2",
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
                
                const SizedBox(height: 40),
                MyElevatedButton(
                  height: 50,
                  width: 260,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(20),
                  startColor: Colors.red,
                  endColor: Colors.red.withOpacity(0.75),
                  hoverColor: Colors.red,
                  child: Text(
                    "C1",
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
                const SizedBox(height: 20),
                MyElevatedButton(
                  height: 50,
                  width: 260,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(20),
                  startColor: Colors.red,
                  endColor: Colors.red.withOpacity(0.75),
                  hoverColor: Colors.red,
                  child: Text(
                    "C2",
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
              ],
            ),
        ),
      );
    }
  }

class MyElevatedButton extends StatefulWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Color hoverColor; // New parameter for hover color
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.startColor = Colors.cyan,
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
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(0);
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
          child: widget.child,
        ),
      ),
    );
  }
}



