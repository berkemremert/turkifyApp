import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

import '../wordCardFiles/wordCards.dart';

class ProgressBar extends StatefulWidget {
  final int selectedIndex;
  final double ratio;
  final String level;

  ProgressBar({required this.selectedIndex, required this.ratio, required this.level});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  final List<IconData> _icons = [
    Icons.school,
    Icons.library_books,
    Icons.lightbulb,
    Icons.book,
    Icons.sunny,
    Icons.search,
    Icons.computer,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  double offset = (index % 2 == 0) ? -10.0 : 10.0;
                  bool isClickable = index == widget.selectedIndex;
                  bool isPink = index < widget.selectedIndex;

                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleButton(
                        icon: _icons[index],
                        isSelected: index == widget.selectedIndex,
                        isClickable: isClickable,
                        isPink: isPink,
                        onTap: () {
                          if (isClickable) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(
                                    fontFamily: 'Roboto',
                                  ),
                                  home: WordCards(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58.0),
              child: GlassEffectProgressBar(
                ratio: widget.ratio,
                level: widget.level,
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ],
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final bool isClickable;
  final bool isPink;
  final VoidCallback? onTap;

  CircleButton({
    required this.icon,
    required this.isSelected,
    required this.isClickable,
    required this.isPink,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? baseDeepColor : (isPink ? Colors.red[200] : Colors.grey[300]),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? Colors.white : Colors.black54,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}

class GlassEffectProgressBar extends StatelessWidget {
  final double ratio;
  final String level;

  GlassEffectProgressBar({required this.ratio, required this.level});

  String incrementLevel(String level) {
    if (level == 'A1') {
      return 'A2';
    } else if (level == 'A2') {
      return 'B1';
    } else if (level == 'B1') {
      return 'B2';
    } else if (level == 'B2') {
      return 'C1';
    } else if (level == 'C1') {
      return 'C2';
    } else {
      return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          stops: [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main progress bar
          Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  baseDeepColor.withOpacity(0.4),
                  baseDeepColor.withOpacity(0.2),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            width: (ratio) == 0
                ? (MediaQuery.of(context).size.width - 116) * 0.12
                : (ratio) * (MediaQuery.of(context).size.width - 116),
          ),
          Positioned(
            left: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                level,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                incrementLevel(level),
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
