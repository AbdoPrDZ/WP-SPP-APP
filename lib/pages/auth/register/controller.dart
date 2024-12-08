part of 'page.dart';

class RegisterController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController(text: 'client');
  final emailController = TextEditingController(text: 'client@mail.com');
  final passwordController = TextEditingController(text: '123456');
  final confirmController = TextEditingController(text: '123456');

  Map<String, String> errors = {};

  String? getFieldError(String field) =>
      errors.containsKey(field) ? errors[field] : null;

  void submit() async {
    errors = {};

    if (formKey.currentState?.validate() == true) {
      DialogsView.loading().show();

      final response = await AppAPI.apiClient.post(
        AppAPI.register,
        data: {
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      if (!response.success) {
        await DialogsView.message(
          'register.submit.dialog.title'.tr,
          response.message,
        ).show();

        Get.back();

        errors = response.errors ?? {};

        formKey.currentState?.validate();
      } else {
        RouteManager.to(
          PagesInfo.success,
          arguments: SuccessPageData(
            image: Assets.registerSuccess,
            title: "register_success.title".tr,
            description: "register_success.description".tr,
            onInit: () async {
              final loginResponse = await AppAPI.apiClient.post(
                AppAPI.login,
                data: {
                  'username': usernameController.text.trim(),
                  'password': passwordController.text,
                },
              );

              if (!loginResponse.success) {
                Get.back();

                await DialogsView.message(
                  'register.submit.dialog.title'.tr,
                  loginResponse.message,
                ).show();
              } else {
                await mainService.onAuth(loginResponse.value['token']);
                RouteManager.to(
                  PagesInfo.home,
                  clearHeaders: true,
                );
              }
            },
          ),
          clearHeaders: true,
        );
      }
    }
  }
}
