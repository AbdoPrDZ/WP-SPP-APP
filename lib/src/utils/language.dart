import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../consts/consts.dart';

abstract class Language {
  final String char;
  final String name;
  final Locale locale;

  const Language({
    required this.char,
    required this.name,
    required this.locale,
  });

  Map<String, String> get words => Get.find<MainService>().words[char] ?? {};

  bool get isEn => char == 'en';
  bool get isAr => char == 'ar';
  bool get isFr => char == 'fr';

  String get flag => {
        'en': '🇺🇸',
        'ar': '🇩🇿',
        'fr': '🇫🇷',
      }[char]!;

  Color? get backgroundColor => {
        'en': UIColors.success,
        'ar': null,
        'fr': UIColors.danger,
      }[char];

  static const Language en = EnglishLanguage();
  static const Language ar = ArabicLanguage();
  static const Language fr = FrenchLanguage();

  static List<Language> get all => [en, ar, fr];

  static Language? fromChar(String? char) =>
      char == null ? null : {'en': en, 'ar': ar, 'fr': fr}[char];

  @override
  String toString() => "language.$name".tr;

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    return other is Language && other.char == char;
  }

  bool get isAppLanguage => Get.find<MainService>().appLanguage == this;

  @override
  int get hashCode => Object.hash(char, name, locale);
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': Language.en.words,
        'ar_DZ': Language.ar.words,
        'fr_FR': Language.fr.words,
      };
}

class EnglishLanguage extends Language {
  const EnglishLanguage()
      : super(
          char: 'en',
          name: 'language.en',
          locale: const Locale('en', 'US'),
        );
}

class ArabicLanguage extends Language {
  const ArabicLanguage()
      : super(
          char: 'ar',
          name: 'language.ar',
          locale: const Locale('ar', 'DZ'),
        );
}

class FrenchLanguage extends Language {
  const FrenchLanguage()
      : super(
          char: 'fr',
          name: 'language.fr',
          locale: const Locale('fr', 'FR'),
        );
}
