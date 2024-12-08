part of 'page.dart';

class LoginController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, String> errors = {};

  String? getFieldError(String field) =>
      errors.containsKey(field) ? errors[field] : null;

  void login() async {
    errors = {};

    if (formKey.currentState?.validate() == true) {
      DialogsView.loading().show();

      final response = await AppAPI.apiClient.post(
        AppAPI.login,
        data: {
          'username': usernameController.text.trim(),
          'password': passwordController.text,
        },
      );

      print(response.statusCode);
      print(response.body);

      String message = response.message;

      final value = response.value;

      if (value is Map && value.containsKey('token')) {
        if (await mainService.onAuth(value["token"])) {
          return RouteManager.to(PagesInfo.home, clearHeaders: true);
        }

        message = 'some-things-wrong'.tr;
      } else {
        errors = response.errors ?? {};

        formKey.currentState?.validate();

        await DialogsView.message(
          'login.submit.dialog.title'.tr,
          message,
        ).show();
      }

      Get.back();
    }
  }
}
