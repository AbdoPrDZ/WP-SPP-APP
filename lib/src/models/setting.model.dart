import 'package:get/get.dart';
import 'package:storage_database/storage_database.dart';

import '../../services/main.service.dart';
import '../src.dart';

class SettingModel {
  String? token;
  UIThemeMode themeMode;
  Language language;
  bool firstOpen;
  String apiIP;

  SettingModel({
    this.token,
    this.themeMode = UIThemeMode.dark,
    this.language = Language.en,
    this.firstOpen = true,
    this.apiIP = AppAPI.defaultApiIP,
  });

  static MainService get mainService => Get.find();

  static StorageDatabase get storageDatabase => mainService.storageDatabase;

  static StorageCollection get collection =>
      storageDatabase.collection('setting');

  static SettingModel fromMap(Map data) => SettingModel(
        token: data['token'],
        themeMode: data['theme_mode'] != null
            ? UIThemeMode.fromString(data['theme_mode'])
            : UIThemeMode.dark,
        language: Language.fromChar(data['language']) ?? Language.en,
        firstOpen: data['first_open'] ?? true,
        apiIP: data['api_ip'] ?? AppAPI.defaultApiIP,
      );

  static Future<bool> init() async {
    storageDatabase.initAPI(
      apiUrl: '${AppAPI.appApiIP}/wp-json',
      getHeaders: (url) => AppAPI.authHeaders,
      log: AppAPI.debug,
    );
    return true;
  }

  static Future load() async {
    await collection.set({});

    mainService.setting = SettingModel.fromMap(await collection.get());
  }

  Future updateFromUserSettings(Map<String, dynamic> setting) {
    themeMode = setting['theme_mode'] != null
        ? UIThemeMode.fromString(setting['theme_mode'])
        : UIThemeMode.dark;
    language = Language.fromChar(setting['language']) ?? Language.en;

    return save();
  }

  Future save() => collection.set(data);

  Map<String, dynamic> get data => {
        'token': token,
        'theme_mode': '$themeMode',
        'language': language.char,
        'first_open': firstOpen,
        'api_ip': apiIP,
      };
}
