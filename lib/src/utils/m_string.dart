import 'package:get/get.dart';

import '../../services/main.service.dart';
import 'm_datetime.dart';

/// Extension for String
extension MString on String {
  int get tryToInt => int.tryParse(this) ?? 0;

  int get toInt => int.parse(this);

  double get tryToDouble => double.tryParse(this) ?? 0;

  double get toDouble => double.parse(this);

  bool get tryToBool => this == 'true';

  bool get toBool {
    switch (this) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        throw 'Invalid boolean string';
    }
  }

  DateTime? toDate({String format = 'yyyy-MM-dd HH:mm:ss'}) =>
      MDateTime.fromString(this, format: format);

  String get clearTags => replaceAll(RegExp(r'<[^>]*>'), '');
}

class TString {
  final String en;
  final String ar;
  final String fr;

  const TString({
    required this.en,
    required this.ar,
    required this.fr,
  });

  @override
  String toString() => {
        'en': en,
        'ar': ar,
        'fr': fr,
      }[Get.find<MainService>().appLanguage.char]!;

  static TString? getIfExists({String? en, String? ar, String? fr}) =>
      en != null && ar != null && fr != null
          ? TString(en: en, ar: ar, fr: fr)
          : null;

  static TString? fromData(Map data, [String? prefix]) => getIfExists(
        en: data['${prefix != null ? "${prefix}_" : ""}en'],
        ar: data['${prefix != null ? "${prefix}_" : ""}ar'],
        fr: data['${prefix != null ? "${prefix}_" : ""}fr'],
      );

  static const TString empty = TString(en: '', ar: '', fr: '');
}
