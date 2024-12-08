import 'package:storage_database/api/api.dart';

import '../src.dart';

class DataCollection<T> {
  final Map data;
  final String itemsFieldName;
  final List<T> Function(List items)? itemsEncoder;

  const DataCollection({
    required this.data,
    required this.itemsFieldName,
    this.itemsEncoder,
  });

  factory DataCollection.response(
    APIResponse response, {
    required String itemsFieldName,
    required List<T> Function(List items) itemsEncoder,
  }) {
    if (!response.success) {
      throw Exception("Cannot collect the data from unsuccess response");
    }

    return DataCollection(
      data: response.body,
      itemsFieldName: itemsFieldName,
      itemsEncoder: itemsEncoder,
    );
  }

  factory DataCollection.empty() => const DataCollection(
        data: {
          'items': [],
          'page': 0,
          'pages_count': 0,
          'items_count': 0,
          'total_count': 0,
        },
        itemsFieldName: 'items',
      );

  int get page {
    if (!data.keys.contains('page')) {
      throw Exception("Invalid response, cannot find page key");
    }

    return data['page'];
  }

  int get pagesCount {
    if (!data.keys.contains('pages_count')) {
      throw Exception("Invalid response, cannot find pages_count key");
    }

    return data['pages_count'];
  }

  int get itemsCount {
    if (!data.keys.contains('items_count')) {
      throw Exception("Invalid response, cannot find items_count key");
    }

    return data['items_count'];
  }

  int get totalItemsCount {
    if (!data.keys.contains('total_count')) {
      throw Exception("Invalid response, cannot find total_count key");
    }

    return data['total_count'];
  }

  List get items {
    if (!data.keys.contains(itemsFieldName)) {
      throw Exception("Invalid response, cannot find $itemsFieldName key");
    }

    final itemsData = data[itemsFieldName];

    return itemsData;
  }

  List<T> get encodedItems {
    if (items.isEmpty) return [];

    if (itemsEncoder == null) {
      throw Exception("Items Encoder is required");
    }

    return itemsEncoder!(items);
  }
}

class CollectOptions {
  final int itemsPerPage;
  final int page;
  final String sortBy;
  final SortType sortType;
  final Map<String, dynamic> searchFields;
  final DateTime? date;
  final DateCompare dateCompare;

  const CollectOptions({
    this.itemsPerPage = 10,
    this.page = 1,
    this.sortBy = 'created_at',
    this.sortType = SortType.asc,
    this.searchFields = const {},
    this.date,
    this.dateCompare = DateCompare.at,
  });

  List<String> get query => [
        'itemsPerPage=$itemsPerPage',
        'page=$page',
        'sortBy=$sortBy',
        'sortType=$sortType',
        if (searchFields.isNotEmpty)
          'searchFields=${searchFields.keys.join(',')}',
        for (String field in searchFields.keys)
          '${field == '*' ? 'searchText' : field}=${searchFields[field]}',
        if (date != null)
          'date=${date!.millisecondsSinceEpoch ~/ 1000}&dateCompare=$dateCompare',
      ];

  CollectOptions copyWith({
    int? itemsPerPage,
    int? page,
    String? sortBy,
    SortType? sortType,
    Map<String, dynamic>? searchFields,
    DateTime? date,
    DateCompare? dateCompare,
  }) =>
      CollectOptions(
        itemsPerPage: itemsPerPage ?? this.itemsPerPage,
        page: page ?? this.page,
        sortBy: sortBy ?? this.sortBy,
        sortType: sortType ?? this.sortType,
        searchFields: searchFields ?? this.searchFields,
        dateCompare: dateCompare ?? this.dateCompare,
      );

  CollectOptions copyWithDate({
    DateTime? date,
  }) =>
      CollectOptions(
        itemsPerPage: itemsPerPage,
        page: page,
        sortBy: sortBy,
        sortType: sortType,
        searchFields: searchFields,
        dateCompare: dateCompare,
        date: date,
      );
}
