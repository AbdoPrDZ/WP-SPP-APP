import 'package:flutter/material.dart';

extension MTextStyle on TextStyle {
  // add + operator to TextStyle class to merge the original TextStyle object with the new object
  TextStyle operator +(TextStyle other) => copyWith(
        inherit: other.inherit,
        background: other.background,
        backgroundColor: other.backgroundColor,
        color: other.color,
        debugLabel: other.debugLabel,
        decoration: other.decoration,
        decorationColor: other.decorationColor,
        decorationStyle: other.decorationStyle,
        decorationThickness: other.decorationThickness,
        fontFamily: other.fontFamily,
        fontFamilyFallback: other.fontFamilyFallback,
        fontFeatures: other.fontFeatures,
        fontSize: other.fontSize,
        fontStyle: other.fontStyle,
        fontVariations: other.fontVariations,
        fontWeight: other.fontWeight,
        foreground: other.foreground,
        height: other.height,
        leadingDistribution: other.leadingDistribution,
        letterSpacing: other.letterSpacing,
        locale: other.locale,
        overflow: other.overflow,
        shadows: other.shadows,
        textBaseline: other.textBaseline,
        wordSpacing: other.wordSpacing,
      );
}
