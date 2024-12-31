import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

export 'm_datetime.dart';
export 'm_duration.dart';
export 'date_compare.dart';
export 'm_string.dart';
export 'm_text_editing_controller.dart';
export 'm_text_style.dart';
export 'route_manager.dart';
export 'page_info.dart';
export 'login_with.dart';
export 'page_data.dart';
export 'language.dart';
export 'phone_number.dart';
export 'data_collection.dart';
export 'size_config.dart';
export 'validator.dart';
export 'secure_storage_database.dart';

enum SortType {
  asc,
  desc;

  bool get isAsc => this == asc;
  bool get isDesc => this == desc;

  @override
  String toString() => {asc: 'asc', desc: 'desc'}[this]!;
}

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  switch (Platform.operatingSystem) {
    case 'android':
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    case 'ios':
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'password';
    case 'web':
      final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      return webInfo.userAgent ?? 'password';
    case 'linux':
      final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.id;
    case 'macos':
      final MacOsDeviceInfo macosInfo = await deviceInfo.macOsInfo;
      return macosInfo.model;
    case 'windows':
      final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.computerName;
    default:
      return 'password';
  }
}
