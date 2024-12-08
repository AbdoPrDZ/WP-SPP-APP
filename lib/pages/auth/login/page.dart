import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/main.service.dart';
import '../../../src/src.dart';
import '../auth.dart';

part 'controller.dart';

class LoginPage extends MGetPage<LoginController> {
  static String name = '/login';

  const LoginPage({super.key});

  @override
  LoginController get initController => LoginController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => authAppBar(context);

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          onChanged: () {
            controller.errors = {};
          },
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 20,
                ),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'login.title'.tr,
                      style: TextStyles.titleBold,
                    ),
                    const Gap(10),
                    Text(
                      'login.description'.tr,
                      style: TextStyles.subMidTitle,
                    ),
                    const Gap(40),
                    TextEditView(
                      controller: controller.usernameController,
                      hint: 'login.username.input_hint'.tr,
                      label: 'login.username.input_label'.tr,
                      validator: Validator.make(
                        'required|between:3,50',
                        'login.username.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.passwordController,
                      hint: 'login.password.input_hint'.tr,
                      label: 'login.password.input_label'.tr,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validator.make(
                        'required|password',
                        'login.password.input_label'.tr,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "login.havent_account".tr),
                      WidgetSpan(
                        child: ButtonView.text(
                          text: 'login.register_button'.tr,
                          onPressed: () => RouteManager.to(PagesInfo.register),
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          borderRadius: 2,
                          padding: EdgeInsets.zero,
                          height: 15,
                          textStyle: TextStyles.smallTitlePrimaryBold,
                        ),
                      )
                    ],
                  ),
                  style: TextStyles.smallTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(20),
              ButtonView.text(
                onPressed: controller.login,
                text: 'login.submit_button'.tr,
                margin: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 56),
              ),
            ],
          ),
        ),
      );
}
