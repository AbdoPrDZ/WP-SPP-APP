part of 'page.dart';

class SubscriptionController extends GetxController {
  MainService mainService = Get.find();

  late AppUserModel? user = mainService.appUser.value;

  final pageData = Get.arguments as SubscriptionPageData;

  late SubscriptionModel subscription = pageData.subscription;

  File? proofImage;

  Function(File?)? get onProofPick => subscription.status.isWaitingProof
      ? (File? image) {
          proofImage = image;
          update();
        }
      : null;

  void submitProof() async {
    if (proofImage == null) {
      DialogsView.message(
        "subscription.upload_proof.dialog.title".tr,
        "subscription.upload_proof.dialog.empty".tr,
      ).show();
      return;
    }

    DialogsView.loading().show();

    final response = await AppAPI.apiClient.post(
      "${AppAPI.subscriptions}/${subscription.id}/proof",
      files: [
        http.MultipartFile.fromBytes(
          "proof",
          proofImage!.readAsBytesSync(),
          filename: proofImage!.path.split("/").last,
        ),
      ],
    );

    await DialogsView.message(
      "subscription.upload_proof.dialog.title".tr,
      response.message.clearTags,
    ).show();

    if (response.success) {
      subscription = await SubscriptionModel.find(
            subscription.id,
          ) ??
          subscription;
      update();
    }

    Get.back();
  }
}
