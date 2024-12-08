import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'services/main.service.dart';
import 'src/consts/consts.dart';
import 'src/utils/utils.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  Get.put(MainService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: "SPP WebView",
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Get.find<MainService>().appLanguage.locale,
        theme: ThemeData(
          fontFamily: TextStyles.fontFamily,
          primaryColor: UIColors.primary,
          // backgroundColor: UIColors.backgroundColor,
          useMaterial3: false,
        ),
        getPages: RouteManager.pages,
        initialRoute: PagesInfo.initialPage.route,
      );
}
