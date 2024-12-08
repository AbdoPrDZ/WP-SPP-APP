import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/main.service.dart';
import '../../../src/src.dart';
import '../../pages.dart';

part 'controller.dart';

class RegisterPage extends MGetPage<RegisterController> {
  static String name = '/register';

  const RegisterPage({super.key});

  @override
  RegisterController get initController => RegisterController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => authAppBar(context);

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          onChanged: () {
            controller.errors = {};
            controller.update();
          },
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'register.title'.tr,
                      style: TextStyles.titleBold,
                    ),
                    const Gap(10),
                    Text(
                      "register.description".tr,
                      style: TextStyles.subMidTitle,
                    ),
                    const Gap(40),
                    TextEditView(
                      controller: controller.usernameController,
                      label: 'register.username.input_label'.tr,
                      hint: 'register.username.input_hint'.tr,
                      validator: Validator.make(
                        'required|between:3,50',
                        'register.username.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.emailController,
                      label: 'register.email.input_label'.tr,
                      hint: 'register.email.input_hint'.tr,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.make(
                        'required|email',
                        'register.email.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.passwordController,
                      label: 'register.password.input_label'.tr,
                      hint: 'register.password.input_hint'.tr,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validator.make(
                        'required|password',
                        'register.password.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.confirmController,
                      label: 'register.confirm_password.input_label'.tr,
                      hint: 'register.confirm_password.input_hint'.tr,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validator.make(
                        'required|password|equals:${controller.passwordController.text},${'register.password.input_label'.tr}',
                        'register.confirm_password.input_label'.tr,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'register.have_account'.tr),
                      WidgetSpan(
                        child: ButtonView.text(
                          text: 'register.login_button'.tr,
                          onPressed: Get.back,
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
                onPressed: controller.submit,
                text: 'register.submit_button'.tr,
                margin: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 56),
              ),
            ],
          ),
        ),
      );
}
