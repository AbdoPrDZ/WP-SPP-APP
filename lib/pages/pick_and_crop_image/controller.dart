part of 'page.dart';

class PickAndCropImageController extends GetxController {
  MainService mainService = Get.find();

  final cropperController = CropController();

  PickAndCropImagePageData pageData = Get.arguments;

  ImageSource? source;

  Rx<File?> image = (null as File?).obs;

  @override
  void onReady() {
    if (image.value == null) pickImage();

    super.onReady();
  }

  Future pickImage() async {
    Widget buildButton(IconData icon, String label, ImageSource source) =>
        SizedBox(
          height: 50,
          child: ButtonView(
            borderRadius: 20,
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: UIThemeColors.text1),
                const Gap(10),
                Text(
                  label,
                  style: TextStyles.midTitleBold,
                ),
              ],
            ),
            onPressed: () {
              this.source = source;
              Get.back();
            },
          ),
        );

    await DialogsView(
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'pick_profile_image.dialog.title'.tr,
              textAlign: TextAlign.start,
              style: TextStyles.titleBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 16,
            ),
            child: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(
                  Icons.camera_outlined,
                  'pick_profile_image.dialog.camera'.tr,
                  ImageSource.camera,
                ),
                const Gap(20),
                buildButton(
                  Icons.image_outlined,
                  'pick_profile_image.dialog.gallery'.tr,
                  ImageSource.gallery,
                ),
              ],
            ),
          ),
        ],
      ),
    ).show();

    if (source == null) {
      Get.back();
    } else {
      XFile? result;

      try {
        result = await ImagePicker().pickImage(source: source!);
      } catch (e) {
        await DialogsView.message(
          'pick_profile_image.error.title'.tr,
          'pick_profile_image.error.message'.tr,
          actions: DialogAction.ok,
        ).show();
      }

      if (result != null) {
        image.value = File(result.path);

        update();
      }

      if (image.value == null) Get.back();
    }
  }

  void crop() async {
    DialogsView.loading().show();

    final ext = image.value!.path.split('.').last;

    final bitmap = await cropperController.croppedBitmap();
    final byteData = await bitmap.toByteData(format: ImageByteFormat.png);
    final bytes = byteData?.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

    if (bytes != null) {
      final explorerFile = mainService.storageDatabase.explorer
          .directory('tmp')
          .file('tmp-${DateTime.now().millisecondsSinceEpoch}.$ext');
      await explorerFile.setBytes(bytes);
      pageData.onDone(explorerFile.ioFile);
    } else {
      pageData.onDone(null);
    }

    Get.back();

    Get.back();
  }
}
