import 'package:alumni_network/ui/common/colors.dart';
import 'package:alumni_network/ui/common/fonts.dart';
import 'package:flutter/material.dart';

class EasyTextButton extends StatelessWidget {
  const EasyTextButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.fontHeight,
    this.fontWeight,
    this.fontFamily,
    this.width,
    this.height,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.blue({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorBlue100,
    this.textColor,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.fontHeight,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 200,
    this.height = 52,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.dialog({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorRedPrimary,
    this.textColor,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.fontHeight = 20 / 16,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 200,
    this.height = 52,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.roundedBlueTextIcon({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorBlue100,
    this.textColor,
    this.borderRadius = 16,
    this.fontSize = 12,
    this.fontHeight,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 92,
    this.height = 32,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.ghost({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = kColorPrimaryInactiveGrey,
    this.borderRadius = 10,
    this.fontSize = 15,
    this.fontHeight,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.width,
    this.height,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.headline1({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = kColorPrimaryGrey,
    this.borderRadius = 10,
    this.fontSize = 26,
    this.fontHeight,
    this.fontWeight = FontWeight.w700,
    this.fontFamily = kFontExo2Bold,
    this.width,
    this.height,
    this.startAlign = false,
    this.borderSide,
  });

  const EasyTextButton.headline2({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = kColorPrimaryGrey,
    this.borderRadius = 10,
    this.fontSize = 20,
    this.fontHeight,
    this.fontWeight = FontWeight.w700,
    this.fontFamily = kFontExo2Bold,
    this.width,
    this.height,
    this.startAlign = false,
    this.borderSide,
  });

  final String text;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? fontHeight;
  final String? fontFamily;
  final bool startAlign;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10)),
          ),
          side: borderSide,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: startAlign ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor ?? kColorPrimaryWhite,
                fontSize: fontSize ?? 16,
                height: fontHeight ?? 1,
                fontWeight: fontWeight ?? FontWeight.w600,
                fontFamily: fontFamily ?? kFontExo2Regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
