import 'package:get/get.dart';
import 'package:storage_database/api/api.dart';

import '../../services/main.service.dart';
import '../src.dart';

class AppAPI {
  static const bool debug = true;

  static const String defaultApiIP = "https://6ed8-105-99-79-96.ngrok-free.app";

  static String get appApiIP => Get.find<MainService>().setting.apiIP;

  static Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language':
            (Get.locale ?? const Locale('en', 'US')).toLanguageTag(),
      };

  static String? get token => Get.find<MainService>().setting.token;

  static Map<String, String> get authHeaders => {
        ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static const String register = 'wp/v2/users/register';

  static const String login = 'jwt-auth/v1/token';

  static const String user = 'wp/v2/users/info';

  static const String privacyPolicy = 'custom/v2/privacy_policy';

  static const String offers = 'custom/v2/offers';

  static const String subscriptions = 'custom/v2/subscriptions';

  static const String media = 'wp/v2/media';

  static const String paymentInformations = 'custom/v2/payment-informations';

  static StorageAPI get apiClient =>
      Get.find<MainService>().storageDatabase.storageAPI;
}
