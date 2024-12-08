import 'dart:developer';

import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../src.dart';

class LazyListView<T> extends StatefulWidget {
  final ScrollController? scrollController;
  final LazyListController<T> controller;
  final Widget? Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? errorBuilder;
  final String? emptyMessage;
  final bool reverse;
  final bool? primary;
  final bool pullRefresh;
  final Function(int page)? onLoadItems;

  const LazyListView({
    super.key,
    this.scrollController,
    required this.controller,
    required this.itemBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.emptyMessage,
    this.reverse = false,
    this.primary,
    this.pullRefresh = true,
    this.onLoadItems,
  });

  @override
  State<LazyListView<T>> createState() => _LazyListViewState<T>();
}

class _LazyListViewState<T> extends State<LazyListView<T>> {
  bool isLoading = true;
  Object? error;

  @override
  void initState() {
    super.initState();

    loadItems();
  }

  Future loadItems({bool refresh = false}) async {
    try {
      isLoading = true;

      //! wait for list view build
      await Future.delayed(const Duration(milliseconds: 50));

      setState(() {});

      await widget.controller.loadMore(refresh: refresh);

      widget.onLoadItems?.call(widget.controller.currentPage);
    } catch (e) {
      error = e;
    }

    isLoading = false;

    try {
      setState(() {});
    } catch (e) {
      log('Error: $e');
    }
  }

  Widget _defaultLoadingBuilder(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(color: UIColors.primary),
        ),
      );

  Widget _buildBody(BuildContext context) => StreamBuilder<List<T>>(
        stream: widget.controller.stream,
        builder: (context, snapshot) {
          List<T> items = snapshot.data ?? [];

          int listItemsCount =
              items.length + (widget.controller.hasMore ? 1 : 0);

          return listItemsCount > 0
              ? ListView.builder(
                  primary: widget.primary,
                  controller: widget.scrollController,
                  itemCount: listItemsCount,
                  reverse: widget.reverse,
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      if (!isLoading) loadItems();

                      return widget.loadingBuilder?.call(context) ??
                          _defaultLoadingBuilder(context);
                    }

                    return widget.itemBuilder(
                      context,
                      items[index],
                      index,
                    );
                  },
                )
              : Center(
                  child: isLoading
                      ? _defaultLoadingBuilder(context)
                      : error != null
                          ? widget.errorBuilder?.call(context) ??
                              Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "lazy_list_view.error_message".tr,
                                    style: TextStyles.subMidTitleBold,
                                  ),
                                  const Gap(15),
                                  ButtonView.icon(
                                    icon: Icons.refresh,
                                    width: 45,
                                    height: 45,
                                    padding: EdgeInsets.zero,
                                    onPressed: () => loadItems(refresh: true),
                                    backgroundColor: UIColors.border,
                                  ),
                                ],
                              )
                          : widget.emptyBuilder?.call(context) ??
                              Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.emptyMessage ??
                                        "lazy_list_view.empty_message".tr,
                                    style: TextStyles.subMidTitleBold,
                                  ),
                                  const Gap(15),
                                  ButtonView.icon(
                                    icon: Icons.refresh,
                                    width: 45,
                                    height: 45,
                                    padding: EdgeInsets.zero,
                                    onPressed: () => loadItems(refresh: true),
                                    backgroundColor: UIColors.border,
                                  ),
                                ],
                              ),
                );
        },
      );

  @override
  Widget build(BuildContext context) => widget.pullRefresh
      ? RefreshIndicator(
          color: UIColors.primary,
          onRefresh: () => loadItems(refresh: true),
          child: _buildBody(context),
        )
      : _buildBody(context);
}

class LazyListController<T> {
  final CollectOptions options;
  final Future<DataCollection<T>> Function(
    CollectOptions options,
  ) collector;

  LazyListController({
    this.options = const CollectOptions(),
    required this.collector,
  });

  final List<T> _items = [];

  List<T> get items => _items;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future loadMore({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _items.clear();
    }

    final collection = await collector(options.copyWith(
      page: _currentPage + 1,
    ));

    _currentPage = collection.page;
    _hasMore = collection.page < collection.pagesCount;
    _items.addAll(collection.encodedItems);

    hasChanges = true;
  }

  void setItem(int index, T item) {
    _items[index] = item;
    hasChanges = true;
  }

  void addItem(T item, [bool top = false]) {
    if (top) {
      _items.insert(0, item);
    } else {
      _items.add(item);
    }
  }

  void setWhere(bool Function(T item) where, T item) =>
      setItem(_items.indexWhere(where), item);

  void removeWhere(bool Function(T item) where) => _items.removeWhere(where);

  bool hasChanges = true;

  Stream<List<T>> get stream async* {
    while (true) {
      if (hasChanges) {
        yield _items;

        hasChanges = false;
      }

      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}
