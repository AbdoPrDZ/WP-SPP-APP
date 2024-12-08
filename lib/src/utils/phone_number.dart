import '../consts/consts.dart';

class PhoneNumber {
  final String countryCode;
  final String number;

  const PhoneNumber({
    required this.countryCode,
    required this.number,
  });

  @override
  String toString() =>
      '${Countries.all[countryCode]?['call_code'] ?? "+213"}$number';
}
