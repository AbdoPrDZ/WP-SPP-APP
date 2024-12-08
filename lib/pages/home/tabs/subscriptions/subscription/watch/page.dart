import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../../../services/main.service.dart';
import '../../../../../../src/src.dart';

part 'controller.dart';
part 'page.data.dart';

class WatchPage extends MGetPage<WatchController> {
  static const String name = '/home/watch';

  const WatchPage({super.key});

  @override
  WatchController get initController => WatchController();

  @override
  bool get canPop {
    if (controller.canGoBack) {
      controller.goBack();
      return false;
    }

    return true;
  }

  Widget buildAction(IconData icon, String tooltip, VoidCallback? onPressed) =>
      ButtonView.icon(
        margin: const EdgeInsets.only(right: 4),
        iconSize: 25,
        width: 30,
        height: 30,
        iconColor: Colors.black,
        borderColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: icon,
      );

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 25),
        child: Container(
          height: kToolbarHeight + 25,
          color: UIColors.primary,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    buildAction(
                      Icons.home,
                      'watch.home'.tr,
                      controller.goHome,
                    ),
                    buildAction(
                      Icons.arrow_back,
                      'watch.back'.tr,
                      controller.goBack,
                    ),
                    buildAction(
                      Icons.refresh,
                      'watch.refresh'.tr,
                      controller.refreshPage,
                    ),
                    buildAction(
                      Icons.arrow_forward,
                      'watch.forward'.tr,
                      controller.goForward,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.pageData.subscription.name,
                              style:
                                  TextStyles.midTitleBold + TextStyles.ellipsis,
                            ),
                            Text(
                              controller.pageData.subscription.description,
                              style: TextStyles.midTitle + TextStyles.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildAction(
                      Icons.exit_to_app,
                      'watch.exit'.tr,
                      () => RouteManager.to(
                        PagesInfo.home,
                        clearHeaders: true,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                value: controller.pageLoadProgress,
              ),
            ],
          ),
        ),
      );

  @override
  Widget buildBody(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: InAppWebView(
              onWebViewCreated: controller.onWebViewCreated,
              shouldInterceptRequest: controller.shouldInterceptRequest,
              shouldOverrideUrlLoading: controller.shouldOverrideUrlLoading,
              onLoadStart: controller.onLoadStart,
              onLoadStop: controller.onLoadStop,
              onProgressChanged: controller.onProgressChanged,
              onReceivedHttpError: controller.onError,
              onReceivedError: controller.onError,
            ),
          ),
          if (controller.loading)
            Positioned.fill(
              child: Container(
                color: const Color(0x66000000),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      );
}
