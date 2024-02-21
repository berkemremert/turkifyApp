// ignore_for_file: camel_case_types, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../themes/config_files/text_config.dart';

///
/// base widget
///
class Text__widget extends StatelessWidget {
  const Text__widget({
    required this.text,
    this.fontSize,
    this.letterSpacing,
    this.height,
    this.fontWeight,
    this.fontFamily,
    this.color,
    this.textAlign,
    this.textOverFlow,
    this.maxLines,
  });

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverFlow,
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily ?? kFontFamily,
        fontWeight: fontWeight ?? kDefaultFontWeight,
        color: color ?? kDefaultTextColor,
        fontSize: fontSize ?? 12,
        letterSpacing: letterSpacing ?? kDefaultLetterSpacing,
        height: height ?? kDefaultLineHeight,
      ),
    );
  }
}

////////////////////////////////////////
/// VARIANTS
////////////////////////////////////////

///
/// display large
/// -----------------------------------------------------------------------------------------------

// class DisplayLarge__text extends StatelessWidget {
//   const DisplayLarge__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_DisplayLarge_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_DisplayLarge_LetterSpacing,
//       height: kConfig_DisplayLarge_LineHeight,
//       fontWeight: fontWeight ?? kConfig_DisplayLarge_FontWeight,
//     );
//   }
// }

// ///
// /// display Medium
// class DisplayMedium__text extends StatelessWidget {
//   const DisplayMedium__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_DisplayMedium_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_DisplayMedium_LetterSpacing,
//       height: kConfig_DisplayMedium_LineHeight,
//       fontWeight: fontWeight ?? kConfig_DisplayMedium_FontWeight,
//     );
//   }
// }

// ///
// /// display Small
// class DisplaySmall__text extends StatelessWidget {
//   const DisplaySmall__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_DisplaySmall_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_DisplaySmall_LetterSpacing,
//       height: kConfig_DisplaySmall_LineHeight,
//       fontWeight: fontWeight ?? kConfig_DisplaySmall_FontWeight,
//     );
//   }
// }

// ///
// /// Headline large
// /// -----------------------------------------------------------------------------------------------
// class HeadlineLarge__text extends StatelessWidget {
//   const HeadlineLarge__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_HeadlineLarge_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_HeadlineLarge_LetterSpacing,
//       height: kConfig_HeadlineLarge_LineHeight,
//       fontWeight: fontWeight ?? kConfig_HeadlineLarge_FontWeight,
//     );
//   }
// }

// ///
// /// Headline Medium
// class HeadlineMedium__text extends StatelessWidget {
//   const HeadlineMedium__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_HeadlineMedium_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_HeadlineMedium_LetterSpacing,
//       height: kConfig_HeadlineMedium_LineHeight,
//       fontWeight: fontWeight ?? kConfig_HeadlineMedium_FontWeight,
//     );
//   }
// }

// ///
// /// Headline Small
// class HeadlineSmall__text extends StatelessWidget {
//   const HeadlineSmall__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_HeadlineSmall_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_HeadlineSmall_LetterSpacing,
//       height: kConfig_HeadlineSmall_LineHeight,
//       fontWeight: fontWeight ?? kConfig_HeadlineSmall_FontWeight,
//     );
//   }
// }

///
/// Title large
/// -----------------------------------------------------------------------------------------------
class TitleLarge__text extends StatelessWidget {
  const TitleLarge__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_TitleLarge_FontSize,
      letterSpacing: letterSpacing ?? kConfig_TitleLarge_LetterSpacing,
      height: kConfig_TitleLarge_LineHeight,
      fontWeight: fontWeight ?? kConfig_TitleLarge_FontWeight,
    );
  }
}

///
/// Title Medium
class TitleMedium__text extends StatelessWidget {
  const TitleMedium__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_TitleMedium_FontSize,
      letterSpacing: letterSpacing ?? kConfig_TitleMedium_LetterSpacing,
      height: kConfig_TitleMedium_LineHeight,
      fontWeight: fontWeight ?? kConfig_TitleMedium_FontWeight,
    );
  }
}

///
/// Title Small
// class TitleSmall__text extends StatelessWidget {
//   const TitleSmall__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_TitleSmall_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_TitleSmall_LetterSpacing,
//       height: kConfig_TitleSmall_LineHeight,
//       fontWeight: fontWeight ?? kConfig_TitleSmall_FontWeight,
//     );
//   }
// }

// ///
// /// Label large
// /// -----------------------------------------------------------------------------------------------
// class LabelLarge__text extends StatelessWidget {
//   const LabelLarge__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_LabelLarge_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_LabelLarge_LetterSpacing,
//       height: kConfig_LabelLarge_LineHeight,
//       fontWeight: fontWeight ?? kConfig_LabelLarge_FontWeight,
//     );
//   }
// }

///
/// Label Medium
class LabelMedium__text extends StatelessWidget {
  const LabelMedium__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_LabelMedium_FontSize,
      letterSpacing: letterSpacing ?? kConfig_LabelMedium_LetterSpacing,
      height: kConfig_LabelMedium_LineHeight,
      fontWeight: fontWeight ?? kConfig_LabelMedium_FontWeight,
    );
  }
}

///
/// Label Small
class LabelSmall__text extends StatelessWidget {
  const LabelSmall__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_LabelSmall_FontSize,
      letterSpacing: letterSpacing ?? kConfig_LabelSmall_LetterSpacing,
      height: kConfig_LabelSmall_LineHeight,
      fontWeight: fontWeight ?? kConfig_LabelSmall_FontWeight,
    );
  }
}

///
/// Body large
/// -----------------------------------------------------------------------------------------------
// class BodyLarge__text extends StatelessWidget {
//   const BodyLarge__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_BodyLarge_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_BodyLarge_LetterSpacing,
//       height: kConfig_BodyLarge_LineHeight,
//       fontWeight: fontWeight ?? kConfig_BodyLarge_FontWeight,
//     );
//   }
// }

///
/// Body Medium
class BodyMedium__text extends StatelessWidget {
  const BodyMedium__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_BodyMedium_FontSize,
      letterSpacing: letterSpacing ?? kConfig_BodyMedium_LetterSpacing,
      height: kConfig_BodyMedium_LineHeight,
      fontWeight: fontWeight ?? kConfig_BodyMedium_FontWeight,
    );
  }
}

///
/// Body Small
class BodySmall__text extends StatelessWidget {
  const BodySmall__text({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.textAlign,
    this.textOverFlow,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text__widget(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      textOverFlow: textOverFlow,
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize ?? kConfig_BodySmall_FontSize,
      letterSpacing: letterSpacing ?? kConfig_BodySmall_LetterSpacing,
      height: kConfig_BodySmall_LineHeight,
      fontWeight: fontWeight ?? kConfig_BodySmall_FontWeight,
    );
  }
}

///
/// Button
/// -----------------------------------------------------------------------------------------------
// class Button__text extends StatelessWidget {
//   const Button__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text.toString().toUpperCase(),
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_Button_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_Button_LetterSpacing,
//       height: kConfig_Button_LineHeight,
//       fontWeight: fontWeight ?? kConfig_Button_FontWeight,
//     );
//   }
// }

// ///
// /// Caption
// /// -----------------------------------------------------------------------------------------------
// class Caption__text extends StatelessWidget {
//   const Caption__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_Caption_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_Caption_LetterSpacing,
//       height: kConfig_Caption_LineHeight,
//       fontWeight: fontWeight ?? kConfig_Caption_FontWeight,
//     );
//   }
// }

// ///
// /// Overline
// /// -----------------------------------------------------------------------------------------------
// class Overline__text extends StatelessWidget {
//   const Overline__text({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.lineHeight,
//     this.letterSpacing,
//     this.textAlign,
//     this.textOverFlow,
//     this.fontFamily,
//     this.maxLines,
//   }) : super(key: key);

//   final String text;
//   final String? fontFamily;
//   final FontWeight? fontWeight;
//   final Color? color;
//   final double? fontSize;
//   final double? letterSpacing;
//   final double? lineHeight;
//   final TextAlign? textAlign;
//   final TextOverflow? textOverFlow;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Text__widget(
//       text: text.toString().toUpperCase(),
//       textAlign: textAlign,
//       maxLines: maxLines,
//       textOverFlow: textOverFlow,
//       fontFamily: fontFamily,
//       color: color,
//       fontSize: fontSize ?? kConfig_Overline_FontSize,
//       letterSpacing: letterSpacing ?? kConfig_Overline_LetterSpacing,
//       height: kConfig_Overline_LineHeight,
//       fontWeight: fontWeight ?? kConfig_Overline_FontWeight,
//     );
//   }
// }
