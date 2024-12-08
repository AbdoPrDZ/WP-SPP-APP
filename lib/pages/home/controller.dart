part of 'page.dart';

class HomeController extends GetxController {
  MainService mainService = Get.find();

  AppUserModel? get user => mainService.appUser.value;

  PageController pageController = PageController();

  List<DrawerItem> get tabs => [
        DrawerItem(
          'home',
          'home.tabs.home'.tr,
          Icons.home_outlined,
          buildTab: (context) => const HomeTab(),
        ),
        DrawerItem(
          'offers',
          'home.tabs.offers'.tr,
          Icons.shopping_cart_outlined,
          buildTab: (context) => const OffersTab(),
        ),
        DrawerItem(
          'subscriptions',
          'home.tabs.subscriptions'.tr,
          Icons.subscriptions_outlined,
          buildTab: (context) => const SubscriptionsTab(),
        ),
        DrawerItem(
          'profile',
          'home.tabs.profile'.tr,
          Icons.person_outline,
          buildTab: (context) => const ProfileTab(),
        ),
        DrawerItem(
          'privacy',
          'home.tabs.privacy'.tr,
          Icons.privacy_tip_outlined,
          buildTab: (context) => const PrivacyTab(),
        ),
        DrawerItem(
          'logout',
          'home.tabs.logout'.tr,
          Icons.logout,
          isAction: true,
          onActionTab: logout,
        ),
      ];

  RxInt currentTabIndex = 0.obs;

  void onTabItemSelected(DrawerItem drawerItem) {
    final index = [for (var tab in tabs) tab.name].indexOf(drawerItem.name);
    _goToTab(index);
  }

  void _goToTab(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
    update();
  }

  void goToTab(String name) {
    final index = [for (var tab in tabs) tab.name].indexOf(name);
    _goToTab(index);
  }

  Future logout() async {
    final confirm = await DialogsView.message(
          'logout.dialog.title'.tr,
          'logout.dialog.message'.tr,
          actions: DialogAction.rYesNo,
        ).show() ??
        false;

    if (confirm) {
      DialogsView.loading().show();
      await mainService.logout();
    }
  }
}
