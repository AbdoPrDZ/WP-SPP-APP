import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../services/main.service.dart';
import '../../../../../src/src.dart';
import 'watch/page.dart';

part 'controller.dart';
part 'page.data.dart';

class SubscriptionPage extends MGetPage<SubscriptionController> {
  static const String name = "/subscription";

  const SubscriptionPage({super.key});

  @override
  SubscriptionController get initController => SubscriptionController();

  Future<Map> loadPaymentInformations() async {
    final response = await AppAPI.apiClient.get(AppAPI.paymentInformations);

    if (!response.success) {
      throw Exception(response.message);
    }

    final data = response.value as Map;

    data.removeWhere((key, value) => value == null || value == '');

    return data;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIColors.primary,
        title: Text("subscription.title".trParams({
          'name': controller.subscription.name,
        })),
      );

  @override
  bool get isScrollable => true;

  @override
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: UserAvatarView.networkImage(
                controller.subscription.previewImageUrl,
                size: 100,
              ),
            ),
            const Gap(10),
            Text(
              controller.subscription.name,
              style: TextStyles.bigTitleBold,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Text(
              "subscription.description".tr,
              style: TextStyles.subMidTitleBold,
            ),
            const Gap(10),
            Text(
              controller.subscription.description,
              style: TextStyles.subMidTitle,
            ),
            const Gap(10),
            Text(
              "subscription.status".tr,
              style: TextStyles.subMidTitleBold,
            ),
            const Gap(10),
            Text(
              "${controller.subscription.status}",
              style: TextStyles.subMidTitle.copyWith(
                color: controller.subscription.status.color,
              ),
            ),
            Text(
              controller.subscription.status.description,
              style: TextStyles.subMidTitle,
            ),
            const Gap(10),
            if (controller.subscription.status.isPending) ...[
              Text(
                "subscription.payment_info".tr,
                style: TextStyles.subMidTitleBold,
              ),
              const Gap(10),
              FutureBuilder<Map>(
                future: loadPaymentInformations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: UIColors.primary),
                    );
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return Text(
                      "subscription.payment_info.error".tr,
                      style: TextStyles.subMidTitle,
                    );
                  }

                  final paymentInformations = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (paymentInformations.isEmpty)
                          Text(
                            "subscription.payment_info.empty".tr,
                            style: TextStyles.midTitleDanger,
                          )
                        else
                          for (final entry in paymentInformations.entries)
                            Row(
                              children: [
                                Text(
                                  "${entry.key}: ",
                                  style: TextStyles.subMidTitleBold,
                                ),
                                Text(
                                  "${entry.value}",
                                  style: TextStyles.subMidTitle,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: UIThemeColors.iconFg1,
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: entry.value),
                                    );
                                    snackText(
                                      "subscription.payment_info.copied"
                                          .trParams({
                                        'target': entry.key,
                                      }),
                                    );
                                  },
                                ),
                              ],
                            ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(20),
              Text(
                "subscription.proof".tr,
                style: TextStyles.subMidTitleBold,
              ),
              const Gap(10),
              ButtonView.imagePick(
                image: controller.proofImage,
                onPick: controller.onProofPick,
                url: controller.subscription.proofImageUrl,
              ),
              if (controller.subscription.status.isWaitingProof) ...[
                const Gap(20),
                ButtonView.text(
                  onPressed: controller.submitProof,
                  text: "subscription.upload_proof.submit".tr,
                ),
              ],
            ],
            if (controller.subscription.status.isActive) ...[
              Text(
                "subscription.expire_at".tr,
                style: TextStyles.subMidTitleBold,
              ),
              const Gap(10),
              StreamBuilder<DateTime>(
                stream: MDateTime.streamNow(),
                builder: (context, snapshot) => Text(
                  controller.subscription.expireAt!.timeLeft.getDisplayString(
                    length: 3,
                  ),
                  style: TextStyles.subMidTitle,
                ),
              ),
              const Gap(40),
              ButtonView.text(
                onPressed: () async {
                  DialogsView.loading().show();

                  final subscriptionInfo =
                      await controller.subscription.subscriptionInfo;

                  if (subscriptionInfo != null) {
                    await RouteManager.to(
                      PagesInfo.watch,
                      arguments: WatchPageData(
                        subscription: controller.subscription,
                        subscriptionInfo: subscriptionInfo,
                      ),
                    );
                  } else {
                    await DialogsView.message(
                      "subscription.watch_dialog.title".tr,
                      "subscription.watch_dialog.error".tr,
                    ).show();
                  }

                  Get.back();
                },
                text: "subscription.watch.submit".tr,
              )
            ],
          ],
        ),
      );
}
