part of 'tab.dart';

class SubscriptionItemView extends StatelessWidget {
  final SubscriptionModel subscription;
  final Function()? onPressed;

  const SubscriptionItemView({
    super.key,
    required this.subscription,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () async {
          await RouteManager.to(
            PagesInfo.subscription,
            arguments: SubscriptionPageData(
              subscription: subscription,
            ),
          );
          onPressed?.call();
        },
        leading: UserAvatarView.networkImage(
          subscription.previewImageUrl,
          size: 50,
        ),
        title: Text(
          subscription.name,
          style: TextStyles.midTitleBold,
        ),
        subtitle: Text(
          subscription.description,
          style: TextStyles.smallTitle,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${subscription.status}',
              style: TextStyles.smallTitle.copyWith(
                color: subscription.status.color,
              ),
            ),
            if (subscription.expireAt != null)
              StreamBuilder<DateTime>(
                stream: MDateTime.streamNow(),
                builder: (context, snapshot) => Text(
                  subscription.expireAt!.timeLeft.getDisplayString(length: 1),
                  style: TextStyles.midTitleBold,
                ),
              ),
          ],
        ),
      );
}
