import 'package:alumni_network/ui/common/colors.dart';
import 'package:alumni_network/ui/common/fonts.dart';
import 'package:flutter/material.dart';

class EasyTextIconButton extends StatelessWidget {
  const EasyTextIconButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderSide = BorderSide.none,
    this.fontSize,
    this.fontHeight,
    this.fontWeight,
    this.fontFamily,
    this.width,
    this.height,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.blue({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorBlue100,
    this.textColor,
    this.borderRadius = 10,
    this.borderSide = BorderSide.none,
    this.fontSize = 16,
    this.fontHeight,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 200,
    this.height = 52,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.grey({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorGreyButton,
    this.textColor = kColorSecondaryGrey,
    this.borderRadius = 10,
    this.borderSide = BorderSide.none,
    this.fontSize = 16,
    this.fontHeight,
    this.fontWeight = FontWeight.w700,
    this.fontFamily,
    this.width = 200,
    this.height = 52,
    this.path,
    this.iconSize = 16,
    this.iconColor = kColorSecondaryGrey,
    this.isIconOnRight = false,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.dialog({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorRedPrimary,
    this.textColor,
    this.borderRadius = 10,
    this.borderSide = BorderSide.none,
    this.fontSize = 16,
    this.fontHeight = 20 / 16,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 200,
    this.height = 52,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.roundedBlueTextIcon({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = kColorBlue100,
    this.textColor,
    this.borderRadius = 16,
    this.borderSide = BorderSide.none,
    this.fontSize = 12,
    this.fontHeight,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.width = 92,
    this.height = 32,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.ghost({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = kColorPrimaryInactiveGrey,
    this.borderRadius = 10,
    this.borderSide = BorderSide.none,
    this.fontSize = 15,
    this.fontHeight,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.width,
    this.height,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  const EasyTextIconButton.headline1({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = kColorPrimaryGrey,
    this.borderRadius = 10,
    this.borderSide = BorderSide.none,
    this.fontSize = 26,
    this.fontHeight,
    this.fontWeight = FontWeight.w700,
    this.fontFamily = kFontExo2Bold,
    this.width,
    this.height,
    this.path,
    this.iconSize = 12,
    this.iconColor,
    this.isIconOnRight = true,
    this.isSpaceBetween = false,
  });

  final String text;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final BorderSide borderSide;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? fontHeight;
  final String? fontFamily;
  final String? path;
  final double? iconSize;
  final Color? iconColor;
  final bool isIconOnRight;
  final bool isSpaceBetween;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? 200,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          shape: RoundedRectangleBorder(
            side: borderSide,
            // side: hasBorder ? BorderSide(
            //   color: borderColor ?? kColorBlue100, // Border color
            //   width: borderRadius ?? 2, // Border thickness
            // ) : BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10)),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: isSpaceBetween ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (path != null && !isIconOnRight)
              Center(
                child: Image.asset(
                  path!,
                  width: iconSize ?? 12,
                  height: iconSize ?? 12,
                  color: iconColor,
                ),
              ),
            if (path != null && !isIconOnRight)
              const SizedBox(
                width: 8,
              ),
            Padding(
              padding: EdgeInsets.only(
                left: isSpaceBetween ? 20 : 0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? kColorPrimaryWhite,
                  fontSize: fontSize ?? 16,
                  height: fontHeight ?? 1,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  fontFamily: fontFamily ?? kFontExo2Regular,
                ),
              ),
            ),
            if (path != null && isIconOnRight)
              const SizedBox(
                width: 8,
              ),
            if (path != null && isIconOnRight)
              Container(
                padding: EdgeInsets.only(
                  right: isSpaceBetween ? 20 : 0,
                ),
                child: Center(
                  child: Image.asset(
                    path!,
                    width: iconSize ?? 12,
                    height: iconSize ?? 12,
                    color: iconColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
