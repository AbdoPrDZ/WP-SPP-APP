import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';

class UIColors {
  // basic
  static const Color primary = Color(0xFF086791);
  static const Color primary2 = Color(0XFFf69808);
  static const Color backgroundColor = Color(0xFF080E1A);
  static const Color success = Color(0xFF4DFC89);
  static const Color info = Color(0xFF128CC0);
  static const Color danger = Color(0XFFE84F4F);
  static const Color fieldDanger = Color(0xFFBE1E1E);
  static const Color warning = Color(0XFFf69808);
  static const Color border = Color(0XFFB2B2B2);
}

class LightTheme {
  static const Map<String, Color?> colors = {
    'pageBackground': Color(0XFFEFEFEF),
    'text1': Color(0XFF000000),
    'text2': Color(0XFF4D4D4D),
    'text3': Color(0XFF727272),
    'iconFg': Color(0XFFEFEFEF),
    'iconFg1': Color(0xFF202020),
    'iconBg': UIColors.primary,
    'field': Color(0X8F757575),
    'fieldBg': Color(0X16797979),
    'fieldText': Color(0XFF424242),
    'fieldFocus': Color(0XFF4387DF),
    'cardBg': Color(0XFFFFFFFF),
    'cardBg1': Color(0XFFF4F4F4),
  };

  static Color? get pageBackground => colors['pageBackground'];
  static Color get primary => colors['primary']!;
  static Color get primary2 => colors['primary2']!;
  static Color get text1 => colors['text1']!;
  static Color get text2 => colors['text2']!;
  static Color get text3 => colors['text3']!;
  static Color get iconBg => colors['iconBg']!;
  static Color get iconFg => colors['iconFg']!;
  static Color get iconFg1 => colors['iconFg1']!;
  static Color get field => colors['field']!;
  static Color get fieldBg => colors['fieldBg']!;
  static Color get fieldText => colors['fieldText']!;
  static Color get fieldFocus => colors['fieldFocus']!;
  static Color get cardBg => colors['cardBg']!;
  static Color get cardBg1 => colors['cardBg1']!;
}

class DarkTheme {
  static const Map<String, Color?> colors = {
    'pageBackground': Color(0xFF202020),
    'text1': Color(0xFFFFFFFF),
    'text2': Color(0xFFB2B2B2),
    'text3': Color(0xFF8D8D8D),
    'iconFg': Color(0xFF202020),
    'iconFg1': Color(0XFFEFEFEF),
    'iconBg': UIColors.primary,
    'field': Color(0x8FFFFFFF),
    'fieldBg': Color(0x1DFFFFFF),
    'fieldText': Color(0xFFEBEBEB),
    'fieldFocus': UIColors.primary2,
    'cardBg': Color(0xFF202020),
    'cardBg1': Color(0xFFEAEAEA),
  };

  static Color get pageBackground => colors['pageBackground']!;
  static Color get text1 => colors['text1']!;
  static Color get text2 => colors['text2']!;
  static Color get text3 => colors['text3']!;
  static Color get iconBg => colors['iconBg']!;
  static Color get iconFg => colors['iconFg']!;
  static Color get iconFg1 => colors['iconFg1']!;
  static Color get field => colors['field']!;
  static Color get fieldBg => colors['fieldBg']!;
  static Color get fieldText => colors['fieldText']!;
  static Color get fieldFocus => colors['fieldFocus']!;
  static Color get cardBg => colors['cardBg']!;
  static Color get cardBg1 => colors['cardBg1']!;
}

class UIThemeColors extends Color {
  UIThemeColors(super.value);

  static UIThemeMode get themeMode => Get.find<MainService>().themeMode;

  static Map<String, Color?> get colors =>
      (themeMode.isDark ? DarkTheme.colors : LightTheme.colors);

  static Color? get pageBackground => colors['pageBackground'];
  static Color get text1 => colors['text1']!;
  static Color get text2 => colors['text2']!;
  static Color get text3 => colors['text3']!;
  static Color get iconBg => colors['iconBg']!;
  static Color get iconFg => colors['iconFg']!;
  static Color get iconFg1 => colors['iconFg1']!;
  static Color get field => colors["field"]!;
  static Color get fieldBg => colors["fieldBg"]!;
  static Color get fieldText => colors["fieldText"]!;
  static Color get fieldFocus => colors["fieldFocus"]!;
  static Color get cardBg => colors["cardBg"]!;
  static Color get cardBg1 => colors["cardBg1"]!;
}

enum UIThemeMode {
  dark,
  light;

  static UIThemeMode fromString(String mode) => {
        'light': light,
        'dark': dark,
      }[mode]!;

  bool get isDark => this == dark;
  bool get isLight => this == light;

  @override
  String toString() => {light: 'light', dark: 'dark'}[this]!;
}
