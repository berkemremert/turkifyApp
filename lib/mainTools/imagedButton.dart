import 'package:flutter/material.dart';

class ImagedButton extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final VoidCallback onTap;
  final bool? isCall;
  final double? ratio;
  final double? shadowRadius;
  final double? blurRadius;
  final double? padding;
  final FontWeight? fontWeight;
  final double? imageOpacity;
  final double? letterSpacing;

  const ImagedButton({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.onTap,
    this.isCall,
    this.ratio,
    this.shadowRadius,
    this.blurRadius,
    this.padding,
    this.fontWeight,
    this.imageOpacity,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 55.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: shadowRadius ?? 2,
                blurRadius: blurRadius ?? 5,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: ratio ?? 5 / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(isCall?? false ? 0.6 : (imageOpacity ?? 0.3)),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 10,
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isCall ?? false
                        ? Row(
                            children: [
                              const SizedBox(width: 30),
                              Image.asset(
                                'assets/phoneRing.gif',
                                height: 50,
                                width: 50,
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textOrganizer(buttonText)['name'] ?? "",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        textOrganizer(buttonText)['text'] ?? "",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            buttonText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 36,
                              letterSpacing: letterSpacing ?? 1,
                              fontWeight: fontWeight ?? FontWeight.w400,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> textOrganizer(String text) {
    Map<String, String> teext = {};

    List<String> parts = text.split('\n');

    teext['name'] = parts[0];
    teext['text'] = parts[1];

    return teext;
  }
}
