part of 'tab.dart';

class SettingsController extends GetxController {
  MainService mainService = Get.find();

  AppUserModel get appUser => mainService.appUser.value!;

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final descriptionController = TextEditingController();

  File? newImage;

  Map<String, String> errors = {};

  String? getFieldError(String field) =>
      errors.containsKey(field) ? errors[field] : null;

  @override
  void onInit() {
    firstNameController.text = appUser.firstName ?? '';
    lastNameController.text = appUser.lastName ?? '';
    descriptionController.text = appUser.description ?? '';

    super.onInit();
  }

  void onPickImage(File? image) {
    newImage = image;
    update();
  }

  void submit() async {
    errors = {};

    if (formKey.currentState?.validate() == true) {
      bool confirm = await DialogsView.message(
            'edit_profile.submit_dialog.title'.tr,
            'edit_profile.submit_dialog.confirm_message'.tr,
            actions: DialogAction.rYesNo,
          ).show() ??
          false;

      if (!confirm) return;

      final data = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'description': descriptionController.text,
      };

      if (data.isEmpty) return;

      DialogsView.loading().show();

      final response = await AppAPI.apiClient.post(
        AppAPI.user,
        data: data,
        files: [
          if (newImage != null)
            await http.MultipartFile.fromPath('profile_photo', newImage!.path),
        ],
      );

      await DialogsView.message(
        'edit_profile.submit_dialog.title'.tr,
        response.message,
      ).show();

      if (response.success) {
        mainService.appUser.value =
            await AppUserModel.get(mainService.setting.token!);
        Get.back();
      } else {
        errors = response.errors ?? {};

        formKey.currentState?.validate();
      }

      Get.back();
    }
  }
}
