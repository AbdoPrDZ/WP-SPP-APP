import '../../../../src/src.dart';
import 'offer/page.dart';

part 'item.view.dart';

class OffersTab extends StatelessWidget {
  const OffersTab({super.key});

  @override
  Widget build(BuildContext context) => LazyListView(
        controller: LazyListController(
          collector: OfferModel.all,
          options: const CollectOptions(),
        ),
        itemBuilder: (context, offer, index) => OfferItemView(offer: offer),
      );
}
