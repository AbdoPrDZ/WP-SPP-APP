import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../services/main.service.dart';
import '../../../../../src/src.dart';

part 'controller.dart';
part 'page.data.dart';

class OfferPage extends MGetPage<OfferController> {
  static String name = "/home/offers/offer";

  const OfferPage({super.key});

  @override
  OfferController get initController => OfferController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIColors.primary,
        title: Text(
          "offer.title".trParams({'name': controller.offer.hostName}),
        ),
      );

  @override
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: UserAvatarView.networkImage(
                controller.offer.imageUrl,
                size: 100,
              ),
            ),
            const Gap(10),
            Text(
              controller.offer.hostName,
              style: TextStyles.bigTitleBold,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Text(
              "offer.description".tr,
              style: TextStyles.subMidTitleBold,
            ),
            const Gap(10),
            Text(
              controller.offer.description,
              style: TextStyles.subMidTitle,
            ),
            const Gap(10),
            const Spacer(),
            Text(
              "offer.prices".tr,
              style: TextStyles.titleBold,
            ),
            const Gap(15),
            CarouselSlider(
              carouselController: controller.carouselController,
              items: [
                for (var price in controller.offer.prices)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: UIThemeColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price.name,
                          style: TextStyles.titleBold,
                        ),
                        const Gap(10),
                        Text(
                          "${price.amount} DZD",
                          style: TextStyles.bigTitleSuccessBold,
                        ),
                        const Gap(10),
                        Text(
                          "offer.price.description".tr,
                          style: TextStyles.subMidTitleBold,
                        ),
                        Text(price.description, style: TextStyles.subMidTitle),
                        const Gap(10),
                        Text(
                          "offer.price.features".tr,
                          style: TextStyles.subMidTitleBold,
                        ),
                        for (final feature in price.features)
                          Text.rich(
                            TextSpan(
                              style: TextStyles.subMidTitle,
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.check,
                                    size: 15,
                                    color: UIColors.success,
                                  ),
                                ),
                                TextSpan(text: " $feature"),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ButtonView.textIcon(
                            height: null,
                            "offer.subscribe".tr,
                            onPressed: () => controller.onSubscribe(price),
                            icon: Icons.shopping_cart,
                            borderRadius: 10,
                            backgroundColor: UIColors.success,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: true,
                onPageChanged: controller.onPriceChanged,
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: controller.onPriceBack,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: UIColors.primary,
                  ),
                ),
                Text(
                  "${controller.currentPriceIndex + 1}/${controller.offer.prices.length}",
                  style: TextStyles.subMidTitle,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: controller.onPriceNext,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: UIColors.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      );
}
