import 'dart:convert';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_database.dart';

import '../src/src.dart';

class MainService extends GetxService with WidgetsBindingObserver {
  StorageDatabase? _storageDatabase;
  StorageDatabase get storageDatabase => _storageDatabase!;

  SettingModel setting = SettingModel();

  Rx<AppUserModel?> appUser = (null as AppUserModel?).obs;

  UIThemeMode themeMode = UIThemeMode.dark;

  Language appLanguage = Language.en;

  Map<String, Map<String, String>> words = {
    'en': {},
    'ar': {},
    'fr': {},
  };

  bool isAuth = false;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  Future loadAppWords() async {
    for (final lang in ['en', 'ar', 'fr']) {
      try {
        final fileWords = Map<String, String>.from(jsonDecode(
          await DefaultAssetBundle.of(Get.context!)
              .loadString('assets/lang/$lang.json'),
        ));

        words[lang]!.addAll(fileWords);
      } catch (e) {
        print(e);
        print("Failed to load $lang.json");
      }
    }
  }

  Future<bool> initApp() async {
    if (_storageDatabase == null) {
      _storageDatabase = StorageDatabase(await SecureStorageDatabase.instance);

      await storageDatabase.initExplorer();
      await storageDatabase.explorer.initNetWorkFiles();

      await loadAppWords();

      await SettingModel.load();

      updateAppTheme();

      updateAppLanguage();

      FlutterNativeSplash.remove();
    }

    return await SettingModel.init();
  }

  void updateAppTheme() {
    if (setting.themeMode != themeMode) {
      themeMode = setting.themeMode;

      Get.forceAppUpdate();
    }
  }

  void updateAppLanguage() {
    if (setting.language != appLanguage) {
      appLanguage = setting.language;

      Get.updateLocale(appLanguage.locale);
      Get.forceAppUpdate();
    }
  }

  Future setThemeMode(UIThemeMode themeMode) async {
    setting.themeMode = themeMode;

    await setting.save();

    updateAppTheme();
  }

  Future setAppLanguage(Language language) async {
    setting.language = language;

    await setting.save();

    updateAppLanguage();
  }

  Future<bool> onAuth(String token) async {
    appUser.value = await AppUserModel.get(token);

    if (appUser.value != null) {
      setting.token = token;

      if (setting.firstOpen) setting.firstOpen = false;

      isAuth = true;

      updateAppTheme();

      updateAppLanguage();

      await setting.save();
    }

    return appUser.value != null;
  }

  Future logout() async {
    isAuth = false;

    setting.token = null;
    await setting.save();

    RouteManager.to(PagesInfo.login, clearHeaders: true);
  }
}
