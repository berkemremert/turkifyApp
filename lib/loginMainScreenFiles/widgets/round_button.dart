import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

import '../../settingsPageFiles/settingsPageTutor.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    required this.loadingController,
    this.interval = const Interval(0, 1, curve: Curves.ease),
    this.size = 60,
    required this.isRead,
  });

  final Widget? icon;
  final VoidCallback onPressed;
  final String? label;
  final AnimationController? loadingController;
  final Interval interval;
  final double size;
  final bool isRead;

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleLoadingAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _scaleLoadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.loadingController!,
        curve: widget.interval,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: .75).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
        reverseCurve: const ElasticInCurve(0.3),
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScaleTransition(
        scale: _scaleLoadingAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: baseDeepColor,
                        heroTag: null,
                        onPressed: () {
                          _pressController.forward().then((_) {
                            _pressController.reverse();
                          });
                          widget.onPressed();
                        },
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    child: Icon(
                      Icons.notifications,
                      color: widget.isRead ? notificationColor() : Colors.transparent,
                      size: 25,
                    ),
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: (widget.isRead) ? Colors.black : Colors.transparent,
                    // ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.label!,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: !SettingsPageTutor.isDarkMode ? const Color.fromARGB(255, 31, 28, 55) : Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
