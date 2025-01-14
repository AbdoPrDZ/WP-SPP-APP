import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/main.service.dart';
import '../src/consts/consts.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == PagesInfo.initialPage.route) return null;

    MainService mainService = Get.find();

    if (PagesInfo.verifySkippedPages.contains(route)) {
      return null;
    } else if (mainService.isAuth && PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onAuthPage.route);
    } else if (!mainService.isAuth && !PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onUnAuth.route);
    }

    return null;
  }
}
