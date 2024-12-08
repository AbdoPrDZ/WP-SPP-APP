import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

export 'login/page.dart';

export 'register/page.dart';

MainService get mainService => Get.find<MainService>();

SettingModel get setting => mainService.setting;

PreferredSizeWidget? authAppBar(BuildContext context) => PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (Navigator.canPop(context))
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              const Spacer(),
              DropDownView<Language>(
                width: 60,
                height: 35,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                value: setting.language,
                items: [
                  for (final lang in Language.all)
                    DropdownMenuItem(
                      value: lang,
                      child: Text(lang.char.toUpperCase()),
                    ),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    DialogsView.loading().show();

                    setting.language = value;
                    await setting.save();

                    mainService.updateAppLanguage();

                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
