import 'package:get/get.dart';

extension MDuration on Duration {
  String getDisplayString({int length = 6}) {
    int seconds = inSeconds;
    int years = seconds ~/ (365 * 24 * 3600);
    seconds %= (365 * 24 * 3600);
    int months = seconds ~/ (30 * 24 * 3600);
    seconds %= (30 * 24 * 3600);
    int days = seconds ~/ (24 * 3600);
    seconds %= (24 * 3600);
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    return [
      if (years > 0) "$years ${"year".tr}",
      if (months > 0) "$months ${"month".tr}",
      if (days > 0) "$days ${"day".tr}",
      if (hours > 0) "$hours ${"hr".tr}",
      if (minutes > 0) "$minutes ${"min".tr}",
      if (seconds > 0) "$seconds ${"sec".tr}",
      if (years == 0 &&
          months == 0 &&
          days == 0 &&
          hours == 0 &&
          minutes == 0 &&
          seconds == 0)
        'just now'.tr,
    ].take(length).join(' ');
  }
}
