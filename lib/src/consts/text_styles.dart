import 'package:flutter/material.dart';

import '../utils/m_text_style.dart';
import 'ui_theme.dart';

class TextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle roboto = TextStyle(fontFamily: fontFamily);

  static TextStyle primary1 = const TextStyle(color: UIColors.primary) + roboto;
  static TextStyle primary2 =
      const TextStyle(color: UIColors.primary2) + roboto;
  static TextStyle success = const TextStyle(color: UIColors.success) + roboto;
  static TextStyle info = const TextStyle(color: UIColors.info) + roboto;
  static TextStyle danger = const TextStyle(color: UIColors.danger) + roboto;
  static TextStyle fieldDanger =
      const TextStyle(color: UIColors.fieldDanger) + roboto;
  static TextStyle warning = const TextStyle(color: UIColors.warning) + roboto;

  static TextStyle get text => TextStyle(color: UIThemeColors.text1) + roboto;
  static TextStyle get subText =>
      TextStyle(color: UIThemeColors.text2) + roboto;
  static TextStyle get subText2 =>
      TextStyle(color: UIThemeColors.text3) + roboto;

  static TextStyle h1 = const TextStyle(fontSize: 30) + roboto;
  static TextStyle h2 = const TextStyle(fontSize: 24) + roboto;
  static TextStyle h3 = const TextStyle(fontSize: 20.8) + roboto;
  static TextStyle h4 = const TextStyle(fontSize: 16) + roboto;
  static TextStyle h5 = const TextStyle(fontSize: 12.8) + roboto;
  static TextStyle h6 = const TextStyle(fontSize: 11.2) + roboto;

  static TextStyle bold = const TextStyle(fontWeight: FontWeight.bold) + roboto;

  static TextStyle ellipsis = const TextStyle(overflow: TextOverflow.ellipsis);

  static TextStyle h1Bold = h1 + bold;
  static TextStyle h2Bold = h2 + bold;
  static TextStyle h3Bold = h3 + bold;
  static TextStyle h4Bold = h4 + bold;
  static TextStyle h5Bold = h5 + bold;
  static TextStyle h6Bold = h6 + bold;

  // Big Text
  static TextStyle get bigTitle => text + h1;
  static TextStyle get bigTitleBold => bigTitle + bold;
  static TextStyle get bigTitlePrimary => bigTitle + primary1;
  static TextStyle get bigTitlePrimaryBold => bigTitlePrimary + bold;
  static TextStyle get bigTitleSuccess => bigTitle + success;
  static TextStyle get bigTitleSuccessBold => bigTitleSuccess + bold;
  static TextStyle get bigTitleDanger => bigTitle + danger;
  static TextStyle get bigTitleDangerBold => bigTitleDanger + bold;

  // Sub Big Text
  static TextStyle get subBigTitle => bigTitle + subText;
  static TextStyle get subBigTitleBold => bigTitleBold + subText;

  // Title
  static TextStyle get title => text + h2;
  static TextStyle get titleBold => title + bold;
  static TextStyle get titlePrimary => title + primary1;
  static TextStyle get titlePrimaryBold => titlePrimary + bold;
  static TextStyle get titleSuccess => title + success;
  static TextStyle get titleSuccessBold => titleSuccess + bold;
  static TextStyle get titleDanger => title + danger;
  static TextStyle get titleDangerBold => titleDanger + bold;
  static TextStyle get titleWarning => title + warning;
  static TextStyle get titleWarningBold => titleWarning + bold;

  // Sub Title
  static TextStyle get subTitle => title + subText;
  static TextStyle get subTitleBold => titleBold + subText;

  // Medium Title
  static TextStyle get midTitle => text + h4;
  static TextStyle get midTitleBold => midTitle + bold;
  static TextStyle get midTitlePrimary => midTitle + primary1;
  static TextStyle get midTitlePrimaryBold => midTitlePrimary + bold;
  static TextStyle get midTitleInfo => midTitle + info;
  static TextStyle get midTitleInfoBold => midTitleInfo + bold;
  static TextStyle get midTitleSuccess => midTitle + success;
  static TextStyle get midTitleSuccessBold => midTitleSuccess + bold;
  static TextStyle get midTitleDanger => midTitle + danger;
  static TextStyle get midTitleDangerBold => midTitleDanger + bold;
  static TextStyle get midTitleFieldDanger => midTitle + fieldDanger;
  static TextStyle get midTitleFieldDangerBold => midTitleFieldDanger + bold;
  static TextStyle get midTitleWarning => midTitle + warning;
  static TextStyle get midTitleWarningBold => midTitleWarning + bold;

  // Sub Medium Title
  static TextStyle get subMidTitle => midTitle + subText;
  static TextStyle get subMidTitle2 => midTitle + subText2;
  static TextStyle get subMidTitleBold => midTitleBold + subText;

  // Small Title
  static TextStyle get smallTitle => text + h5;
  static TextStyle get smallTitleBold => smallTitle + bold;
  static TextStyle get smallTitlePrimary => smallTitle + primary1;
  static TextStyle get smallTitlePrimaryBold => smallTitlePrimary + bold;
  static TextStyle get smallTitleSuccess => smallTitle + success;
  static TextStyle get smallTitleSuccessBold => smallTitleSuccess + bold;
  static TextStyle get smallTitleDanger => smallTitle + danger;
  static TextStyle get smallTitleDangerBold => smallTitleDanger + bold;
  static TextStyle get smallTitleFieldDanger => smallTitle + fieldDanger;
  static TextStyle get smallTitleFieldDangerBold =>
      smallTitleFieldDanger + bold;
  static TextStyle get smallTitleWarning => smallTitle + warning;
  static TextStyle get smallTitleWarningBold => smallTitleWarning + bold;
  static TextStyle get smallTitleInfo => smallTitle + info;
  static TextStyle get smallTitleInfoBold => smallTitleInfo + bold;

  // Sub Small Title
  static TextStyle get subSmallTitle => smallTitle + subText;
  static TextStyle get subSmallTitleBold => smallTitleBold + subText;
  static TextStyle get subSmallTitle2 => smallTitle + subText2;
  static TextStyle get subSmallTitleBold2 => smallTitleBold + subText2;
}
