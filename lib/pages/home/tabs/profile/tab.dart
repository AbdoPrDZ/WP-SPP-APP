import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/src.dart';

part 'controller.dart';

class ProfileTab extends MGetPage<SettingsController> {
  const ProfileTab({super.key});

  @override
  SettingsController get initController => SettingsController();

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatarView.imagePick(
                controller.appUser.profilePhotoUrl,
                controller.appUser.avatarLetters,
                controller.newImage,
                onPick: controller.onPickImage,
                margin: const EdgeInsets.symmetric(vertical: 20),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'profile.personal_details'.tr,
                      style: TextStyles.midTitleBold,
                    ),
                    const Gap(30),
                    TextEditView(
                      controller: controller.firstNameController,
                      label: 'edit_profile.first_name.input_label'.tr,
                      hint: 'edit_profile.first_name.input_hint'.tr,
                      dispose: false,
                      validator: Validator.make(
                        'required|between:3,50',
                        'edit_profile.first_name.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.lastNameController,
                      label: 'edit_profile.last_name.input_label'.tr,
                      hint: 'edit_profile.last_name.input_hint'.tr,
                      dispose: false,
                      validator: Validator.make(
                        'required|between:3,50',
                        'edit_profile.last_name.input_label'.tr,
                      ),
                    ),
                    TextEditView(
                      controller: controller.descriptionController,
                      label: 'edit_profile.description.input_label'.tr,
                      hint: 'edit_profile.description.input_hint'.tr,
                      dispose: false,
                      validator: Validator.make(
                        'required|between:3,255',
                        'edit_profile.description.input_label'.tr,
                      ),
                    ),
                    const Gap(20),
                    ButtonView.text(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      onPressed: controller.submit,
                      text: 'edit_profile.submit_button'.tr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
