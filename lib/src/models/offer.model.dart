import '../src.dart';

class OfferModel {
  final int id;
  final String hostName;
  final String description;
  final String imageUrl;
  final List<OfferPrice> prices;
  final DateTime createdAt;

  const OfferModel({
    required this.id,
    required this.hostName,
    required this.description,
    required this.imageUrl,
    required this.prices,
    required this.createdAt,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) => OfferModel(
        id: int.tryParse("${data['id']}") ?? 0,
        hostName: data['host_name'] as String,
        description: data['description'] as String,
        imageUrl: data['host_preview_image_url'] as String,
        prices: OfferPrice.allFromMap(data['prices'] ?? []),
        createdAt: MDateTime.fromString(
              data['created_at'] ?? '',
            ) ??
            MDateTime.zero,
      );

  static List<OfferModel> allFromMap(List items) =>
      [for (var item in items) OfferModel.fromMap(item)];

  static Future<DataCollection<OfferModel>> all(
    CollectOptions options,
  ) async {
    final response = await AppAPI.apiClient.get(
      '${AppAPI.offers}?${options.query.join('&')}',
    );

    return response.success
        ? DataCollection.response(
            response,
            itemsFieldName: 'offers',
            itemsEncoder: OfferModel.allFromMap,
          )
        : DataCollection.empty();
  }
}

class OfferPrice {
  final int id;
  final String name;
  final String description;
  final double amount;
  final List<String> features;

  const OfferPrice({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.features,
  });

  factory OfferPrice.fromMap(Map<String, dynamic> data) => OfferPrice(
        id: int.tryParse("${data['id']}") ?? 0,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        amount: double.tryParse("${data['amount']}") ?? 0,
        features: data['features']?.toString().split('\n') ?? [],
      );

  static List<OfferPrice> allFromMap(List items) => [
        for (var item in items) OfferPrice.fromMap(item),
      ];
}
