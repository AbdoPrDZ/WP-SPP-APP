import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../src/src.dart';
import '../page.dart';
import 'offers/tab.dart';
import 'subscriptions/tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  HomeController get homeController => Get.find<HomeController>();

  final subscriptionsController = LazyListController(
    collector: SubscriptionModel.all,
  );

  final offersController = LazyListController(collector: OfferModel.all);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  UserAvatarView.networkImageOrAvatarLetter(
                    homeController.user!.profilePhotoUrl,
                    homeController.user!.avatarLetters,
                    size: 65,
                    onPressed: () => homeController.goToTab('profile'),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeController.user!.username,
                        style: TextStyles.titleBold,
                      ),
                      Text(
                        homeController.user!.email,
                        style: TextStyles.subSmallTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Row(
              children: [
                Text(
                  'subscriptions.title'.tr,
                  style: TextStyles.midTitleBold,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => homeController.goToTab('subscriptions'),
                  child: Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: UIThemeColors.text2,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Flexible(
              child: LazyListView(
                controller: subscriptionsController,
                itemBuilder: (context, subscription, index) =>
                    SubscriptionItemView(
                  subscription: subscription,
                  onPressed: () => subscriptionsController.loadMore(
                    refresh: true,
                  ),
                ),
                emptyMessage: 'subscriptions.empty'.tr,
              ),
            ),
            const Gap(20),
            Row(
              children: [
                Text(
                  'offers.title'.tr,
                  style: TextStyles.midTitleBold,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => homeController.goToTab('offers'),
                  child: Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: UIThemeColors.text2,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Flexible(
              child: LazyListView(
                controller: LazyListController(
                  collector: OfferModel.all,
                ),
                itemBuilder: (context, offer, index) => OfferItemView(
                  offer: offer,
                  onPressed: () => offersController.loadMore(refresh: true),
                ),
                emptyMessage: "offers.empty".tr,
              ),
            ),
          ],
        ),
      );
}
