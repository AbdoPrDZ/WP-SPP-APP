import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

part 'controller.dart';
part 'page.data.dart';

class PickAndCropImagePage extends MGetPage<PickAndCropImageController> {
  static String name = '/pick_and_crop_image';

  const PickAndCropImagePage({super.key});

  @override
  PickAndCropImageController get initController => PickAndCropImageController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.cardBg,
        foregroundColor: UIThemeColors.text1,
        title: Text('pick_profile_image.title'.tr),
        actions: [
          TextButton(
            onPressed: controller.crop,
            child: Text(
              'pick_profile_image.done_button'.tr,
              style: TextStyles.midTitleInfoBold,
            ),
          ),
        ],
      );

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: StreamBuilder<File?>(
              stream: controller.image.stream,
              builder: (context, snapshot) => snapshot.data != null
                  ? CropImage(
                      controller: controller.cropperController,
                      image: Image.file(snapshot.data!),
                    )
                  : Container(),
            ),
          ),
          if (controller.image.value != null)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: UIThemeColors.cardBg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.rotate_left,
                      color: UIThemeColors.text2,
                    ),
                    onPressed: () => controller.cropperController.rotateLeft(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.rotate_right,
                      color: UIThemeColors.text2,
                    ),
                    onPressed: () => controller.cropperController.rotateRight(),
                  ),
                ],
              ),
            ),
        ],
      );
}
