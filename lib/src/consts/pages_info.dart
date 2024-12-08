import 'package:get/get.dart';

import '../../middlewares/auth.middleware.dart';
import '../../pages/pages.dart';
import '../utils/utils.dart';

class PagesInfo {
  static Map<String, PageInfo> get pages => {
        LoadingPage.name: PageInfo(
          LoadingPage.name,
          () => const LoadingPage(),
          isUnAuth: true,
        ),
        LoginPage.name: PageInfo(
          LoginPage.name,
          () => const LoginPage(),
          isUnAuth: true,
        ),
        RegisterPage.name: PageInfo(
          RegisterPage.name,
          () => const RegisterPage(),
          isUnAuth: true,
        ),
        SuccessPage.name: PageInfo(
          SuccessPage.name,
          () => const SuccessPage(),
          skipAuthVerify: true,
        ),
        HomePage.name: PageInfo(HomePage.name, () => const HomePage()),
        SubscriptionPage.name:
            PageInfo(SubscriptionPage.name, () => const SubscriptionPage()),
        // WatchPage.name: PageInfo(WatchPage.name, () => const OldHomePage()),
        WatchPage.name: PageInfo(WatchPage.name, () => const WatchPage()),
        OfferPage.name: PageInfo(OfferPage.name, () => const OfferPage()),

        PickAndCropImagePage.name: PageInfo(
          PickAndCropImagePage.name,
          () => const PickAndCropImagePage(),
        ),
      };

  static List<String> get unAuthPages => [
        for (PageInfo page in pages.values)
          if (page.isUnAuth) page.route
      ];

  static List<String> get verifySkippedPages => [
        for (PageInfo page in pages.values)
          if (page.skipAuthVerify) page.route
      ];

  static PageInfo get loading => pages[LoadingPage.name]!;
  static PageInfo get login => pages[LoginPage.name]!;
  static PageInfo get register => pages[RegisterPage.name]!;

  static PageInfo get success => pages[SuccessPage.name]!;

  static PageInfo get home => pages[HomePage.name]!;
  static PageInfo get offer => pages[OfferPage.name]!;
  static PageInfo get subscription => pages[SubscriptionPage.name]!;
  static PageInfo get watch => pages[WatchPage.name]!;

  static PageInfo get pickAndCropImage => pages[PickAndCropImagePage.name]!;

  static PageInfo initialPage = loading;
  static PageInfo onAuthPage = home;
  static PageInfo onUnAuth = login;

  static List<GetMiddleware> appMiddleWares = [AuthMiddleware()];
}
