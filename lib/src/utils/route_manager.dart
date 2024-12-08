import 'package:get/get.dart';

import '../consts/consts.dart';
import 'page_data.dart';
import 'page_info.dart';

class RouteManager {
  static Future<T?>? to<T, PDT extends PageData>(
    PageInfo<PDT> page, {
    bool clearHeaders = false,
    PDT? arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) =>
      clearHeaders
          ? Get.offAllNamed<T>(
              page.route,
              arguments: arguments,
              id: id,
              parameters: parameters,
            )
          : Get.toNamed<T>(
              page.route,
              arguments: arguments,
              id: id,
              preventDuplicates: preventDuplicates,
              parameters: parameters,
            );

  static List<GetPage> get pages => [
        for (PageInfo pageInfo in PagesInfo.pages.values)
          GetPage(
            name: pageInfo.route,
            page: pageInfo.page,
            middlewares: [
              ...PagesInfo.appMiddleWares,
              ...pageInfo.middlewares,
            ],
            title: pageInfo.pageHeaders.title,
            participatesInRootNavigator:
                pageInfo.pageHeaders.participatesInRootNavigator,
            gestureWidth: pageInfo.pageHeaders.gestureWidth,
            maintainState: pageInfo.pageHeaders.maintainState,
            curve: pageInfo.pageHeaders.curve,
            alignment: pageInfo.pageHeaders.alignment,
            parameters: pageInfo.pageHeaders.parameters,
            opaque: pageInfo.pageHeaders.opaque,
            transitionDuration: pageInfo.pageHeaders.transitionDuration,
            popGesture: pageInfo.pageHeaders.popGesture,
            binding: pageInfo.pageHeaders.binding,
            bindings: pageInfo.pageHeaders.bindings,
            transition: pageInfo.pageHeaders.transition,
            customTransition: pageInfo.pageHeaders.customTransition,
            fullscreenDialog: pageInfo.pageHeaders.fullScreenDialog,
            showCupertinoParallax: pageInfo.pageHeaders.showCupertinoParallax,
            preventDuplicates: pageInfo.pageHeaders.preventDuplicates,
          )
      ];
}
