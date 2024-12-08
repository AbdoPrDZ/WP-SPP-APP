import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';
import 'tabs/tabs.dart';

part 'controller.dart';

class HomePage extends MGetPage<HomeController> {
  static const String name = '/home';

  const HomePage({super.key});

  @override
  HomeController get initController => HomeController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIColors.primary,
        title: Obx(
          () => Text(controller.tabs[controller.currentTabIndex.value].text),
        ),
      );

  @override
  Widget? buildDrawer() => CustomDrawerView(
        tabsItems: controller.tabs,
        pageController: controller.pageController,
        onTabItemSelected: controller.onTabItemSelected,
        buildHeader: (context) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            controller.user!.profilePhotoUrl != null
                ? UserAvatarView.networkImage(
                    controller.user!.profilePhotoUrl!,
                    borderSize: 1,
                    size: 80,
                  )
                : UserAvatarView.label(
                    controller.user!.avatarLetters,
                    borderSize: 1,
                    size: 80,
                    textSize: 30,
                  ),
            const Gap(5),
            Text(
              controller.user?.username ?? '',
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
        buildFooter: (context) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SPP WebView",
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Text(
              'SPP WebView\n© All Rights Reserved.',
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  @override
  Widget buildBody(BuildContext context) => PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (DrawerItem item in controller.tabs)
            if (!item.isAction) item.buildTab!(context),
        ],
        onPageChanged: (index) {
          controller.currentTabIndex(index);
          controller.update();
        },
      );
}
