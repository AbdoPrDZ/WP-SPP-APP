part of 'page.dart';

class OfferController extends GetxController {
  MainService mainService = Get.find();

  OfferPageData pageData = Get.arguments;

  OfferModel get offer => pageData.offer;

  final carouselController = CarouselSliderController();

  int currentPriceIndex = 0;

  void onPriceChanged(int index, CarouselPageChangedReason reason) {
    currentPriceIndex = index;
    update();
  }

  VoidCallback? get onPriceBack => currentPriceIndex > 0
      ? () {
          carouselController.previousPage();
        }
      : null;

  VoidCallback? get onPriceNext => currentPriceIndex < offer.prices.length - 1
      ? () {
          carouselController.nextPage();
        }
      : null;

  void onSubscribe(OfferPrice price) async {
    final answer = await DialogsView.message(
      'offer.subscribe_dialog.title'.tr,
      'offer.subscribe_dialog.message'.trParams({
        'amount': price.amount.toStringAsFixed(2),
      }),
      actions: DialogAction.rYesCancel,
    ).show();

    if (answer == true) {
      DialogsView.loading().show();

      final response = await AppAPI.apiClient.post(
        '${AppAPI.offers}/${offer.id}/subscribe',
        data: {'price_id': price.id},
      );

      await DialogsView.message(
        'offer.subscribe_dialog.title'.tr,
        response.success
            ? 'offer.subscribe_dialog.success'.tr
            : response.message,
      ).show();

      Get.back();
    }
  }
}
