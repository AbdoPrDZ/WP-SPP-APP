import 'package:flutter/material.dart';

import 'm_datetime.dart';

extension MTextEditingController on TextEditingController {
  String? get textOrNull => text.isNotEmpty ? text : null;

  double? get doubleOrNull => text.isNotEmpty ? double.tryParse(text) : null;
  double getDoubleOr(double defaultValue) => doubleOrNull ?? defaultValue;
  double get doubleOrZero => getDoubleOr(0);
  double get doubleValue => doubleOrNull!;

  int? get intOrNull => text.isNotEmpty ? int.tryParse(text) : null;
  int getIntOr(int defaultValue) => intOrNull ?? defaultValue;
  int get intOrZero => getIntOr(0);
  int get intValue => intOrNull!;

  Duration? get durationOrNull =>
      intOrNull != null ? Duration(minutes: intOrNull!) : null;
  Duration getDurationOr(Duration defaultValue) =>
      durationOrNull ?? defaultValue;
  Duration get durationOrZero => getDurationOr(Duration.zero);
  Duration get durationValue => durationOrNull!;

  DateTime? get dateTimeOrNull =>
      text.isNotEmpty ? MDateTime.fromString(text) : null;
  DateTime getDateTimeOr(DateTime defaultValue) =>
      dateTimeOrNull ?? defaultValue;
  DateTime get dateTimeValue => dateTimeOrNull!;
}
