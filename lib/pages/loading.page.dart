import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class LoadingPage extends StatefulWidget {
  static String name = '/loading';

  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  MainService get mainService => Get.find();

  Future initApp() async {
    if (await mainService.initApp()) {
      await Future.delayed(const Duration(seconds: 2));

      if (mainService.setting.token != null) {
        await mainService.onAuth(
          mainService.setting.token!,
        );

        if (!mainService.isAuth) {
          mainService.setting.token = null;
          await mainService.setting.save();
        }
      }

      RouteManager.to(
        mainService.setting.firstOpen ? PagesInfo.login : PagesInfo.login,
        clearHeaders: true,
      );
    } else {
      RouteManager.to(PagesInfo.login);
    }
  }

  @override
  Widget build(BuildContext context) => FlutterSplashScreen.scale(
        backgroundColor: UIThemeColors.pageBackground,
        childWidget: Image.asset(
          Assets.logo,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
        ),
        duration: const Duration(milliseconds: 1800),
        animationDuration: const Duration(milliseconds: 1500),
        onEnd: initApp,
        nextScreen: Scaffold(
          backgroundColor: UIThemeColors.pageBackground,
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Spacer(),
                Image.asset(
                  Assets.logo,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
                const Gap(20),
                const CircularProgressIndicator(color: UIColors.primary),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15)
                      .copyWith(bottom: 60),
                  child: Text(
                    'SPP Hosts Application\n© All Rights Reserved.',
                    style: TextStyles.subMidTitle2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
