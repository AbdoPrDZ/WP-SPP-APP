import '../../../../src/src.dart';
import 'subscription/page.dart';

part 'item.view.dart';

class SubscriptionsTab extends StatelessWidget {
  const SubscriptionsTab({super.key});

  @override
  Widget build(BuildContext context) => LazyListView(
        controller: LazyListController(
          collector: SubscriptionModel.all,
          options: const CollectOptions(),
        ),
        itemBuilder: (context, subscription, index) =>
            SubscriptionItemView(subscription: subscription),
      );
}
