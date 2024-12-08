part of 'tab.dart';

class OfferItemView extends StatelessWidget {
  final OfferModel offer;
  final Function()? onPressed;

  const OfferItemView({
    super.key,
    required this.offer,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () async {
          await RouteManager.to(
            PagesInfo.offer,
            arguments: OfferPageData(offer: offer),
          );

          onPressed?.call();
        },
        leading: UserAvatarView.networkImage(
          offer.imageUrl,
          size: 50,
        ),
        title: Text(offer.hostName, style: TextStyles.midTitleBold),
        subtitle: Text(
          offer.description,
          style: TextStyles.smallTitle,
        ),
        trailing: StreamBuilder<DateTime>(
          stream: MDateTime.streamNow(),
          builder: (context, snapshot) => Text(
            offer.createdAt.format('yyyy-MM-dd'),
            textAlign: TextAlign.right,
            style: TextStyles.subMidTitle,
          ),
        ),
      );
}
