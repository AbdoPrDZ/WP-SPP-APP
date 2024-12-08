import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension MDateTime on DateTime {
  DateTime get timeGone => now - this;

  Duration get timeLeft => difference(now);

  DateTime? getTimeLeft(Duration duration) =>
      now.millisecondsSinceEpoch < add(duration).millisecondsSinceEpoch
          ? add(duration) - now
          : null;

  static DateTime fromDate(
    DateTime dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) =>
      DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond,
      );

  static DateTime fromDateAndTImeOfDay(
    DateTime dateTime,
    TimeOfDay time, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) =>
      DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        time.hour,
        time.minute,
        0,
      );

  static DateTime? fromString(
    String date, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    try {
      return fromDate(DateFormat(format).parse(date), format: format);
    } catch (e) {
      return null;
    }
  }

  static DateTime get now => fromDate(DateTime.now());

  static DateTime fromMillisecondsSinceEpoch(int ms) =>
      fromDate(DateTime.fromMillisecondsSinceEpoch(ms));

  static DateTime? fromTimeStamp(int? ts) =>
      ts == null ? null : fromMillisecondsSinceEpoch(ts * 1000);

  static DateTime? fromTimeStampString(String? sts) =>
      sts == null ? null : fromTimeStamp(int.tryParse(sts));

  static DateTime tryFromTimeStamp(int? ts) =>
      ts == null ? zero : fromTimeStamp(ts)!;

  static DateTime? fromTimeStampMap(Map data, String name) =>
      fromTimeStampString(data[name]?.toString());

  static DateTime tryFromTimeStampString(String sts) =>
      tryFromTimeStamp(int.tryParse(sts));

  static DateTime tryFromTimeStampMap(Map? data, String name) =>
      tryFromTimeStampString(data?[name]?.toString() ?? '');

  static DateTime get zero => DateTime(0);

  static Stream<DateTime> streamNow({
    Duration dailyDuration = const Duration(seconds: 1),
  }) async* {
    while (true) {
      yield now;
      await Future.delayed(dailyDuration);
    }
  }

  DateTime operator -(DateTime other) => fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch - other.millisecondsSinceEpoch);

  String format([String format = 'yyyy-MM-dd HH:mm:ss']) =>
      DateFormat(format).format(this);

  String getDisplayString({int limit = 6}) {
    return [
      if (year > 1) "$year ${"year".tr}",
      if (month > 1) "$month ${"month".tr}",
      if (day > 1) "$day ${"day".tr}",
      if (hour > 0) "$hour ${"hr".tr}",
      if (minute > 0) "$minute ${"min".tr}",
      if (second > 0)
        "$second ${"sec".tr}"
      else if (year <= 1 &&
          month <= 1 &&
          day <= 1 &&
          hour <= 0 &&
          minute <= 0 &&
          second <= 0)
        "just now".tr
    ].take(limit).join(" ");
  }
}
