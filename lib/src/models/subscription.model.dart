import 'dart:io';

import 'package:get/get.dart';

import '../src.dart';

class SubscriptionModel {
  final int id;
  final String name;
  final String description;
  final String previewImageUrl;
  final DateTime? expireAt;
  final String? proofImage;
  final SubscriptionStatus status;
  final DateTime createdAt;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.previewImageUrl,
    required this.proofImage,
    required this.status,
    required this.expireAt,
    required this.createdAt,
  });

  String? get proofImageUrl =>
      proofImage == null ? null : "${AppAPI.appApiIP}/${proofImage!}";

  Future<SubscriptionInfo?> get subscriptionInfo async {
    final response = await AppAPI.apiClient.get(
      "${AppAPI.subscriptions}/$id/info",
    );

    // cookie ex: "name=value; domain=example.com; path=/; secure=true; httpOnly=true"
    return response.success && response.value is Map
        ? SubscriptionInfo.fromMap(Map<String, dynamic>.from(response.value))
        : null;
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> data) =>
      SubscriptionModel(
        id: int.tryParse("${data['id']}") ?? 0,
        name: data['host_name'] ?? '',
        description: data['host_description'] ?? '',
        previewImageUrl: data['host_preview_image_url'] ?? '',
        expireAt: MDateTime.fromString(data['expired_at'] ?? ''),
        proofImage: data['proof_url'] ?? '',
        status: SubscriptionStatus.fromString(data['status'] ?? 'deactivated'),
        createdAt:
            MDateTime.fromString(data['created_at'] ?? '') ?? MDateTime.zero,
      );

  static List<SubscriptionModel> allFromMap(
    List mapList,
  ) =>
      [for (var map in mapList) SubscriptionModel.fromMap(map)];

  static Future<DataCollection<SubscriptionModel>> all(
    CollectOptions options,
  ) async {
    final response = await AppAPI.apiClient.get(
      '${AppAPI.subscriptions}?${options.query.join('&')}',
    );

    return response.success
        ? DataCollection.response(
            response,
            itemsFieldName: 'subscriptions',
            itemsEncoder: SubscriptionModel.allFromMap,
          )
        : DataCollection.empty();
  }

  static Future<SubscriptionModel?> find(int id) async {
    final response = await AppAPI.apiClient.get("${AppAPI.subscriptions}/$id");

    return response.success && response.value is Map
        ? SubscriptionModel.fromMap(Map<String, dynamic>.from(response.value))
        : null;
  }
}

class SubscriptionInfo {
  final String hostUrl;
  final List<Cookie> cookies;
  final List<String> blockedUrls;

  const SubscriptionInfo({
    required this.hostUrl,
    required this.cookies,
    required this.blockedUrls,
  });

  factory SubscriptionInfo.fromMap(Map<String, dynamic> data) {
    List<Cookie> cookies = [];

    if (data['cookies'] != null) {
      for (var cookie in data['cookies'].split('\n')) {
        cookies.add(Cookie.fromSetCookieValue(cookie));
      }
    }

    return SubscriptionInfo(
      hostUrl: data['host_url'] ?? '',
      cookies: cookies,
      blockedUrls: (data['blocked_urls'] ?? '').split('\n'),
    );
  }
}

enum SubscriptionStatus {
  waitingProof,
  verifingProof,
  proofRejected,
  activate,
  expired,
  deactivated;

  bool get isWaitingProof => this == waitingProof || this == proofRejected;
  bool get isVerifingProof => this == verifingProof;
  bool get isProofRejected => this == proofRejected;
  bool get isPending => isWaitingProof || isVerifingProof || isProofRejected;
  bool get isActive => this == activate;
  bool get isExpired => this == expired;
  bool get isDeactivated => this == deactivated;

  static SubscriptionStatus fromString(String value) => {
        'waiting_proof': waitingProof,
        'verifing_proof': verifingProof,
        'proof_rejected': proofRejected,
        'activate': activate,
        'expired': expired,
        'deactivated': deactivated,
      }[value]!;

  Color get color => {
        waitingProof: UIColors.warning,
        verifingProof: UIColors.warning,
        proofRejected: UIColors.danger,
        activate: UIColors.success,
        expired: UIColors.danger,
        deactivated: UIThemeColors.field,
      }[this]!;

  String get description => {
        waitingProof: 'subscription.status.waiting_proof.description'.tr,
        verifingProof: 'subscription.status.verifing_proof.description'.tr,
        proofRejected: 'subscription.status.proof_rejected.description'.tr,
        activate: 'subscription.status.activate.description'.tr,
        expired: 'subscription.status.expired.description'.tr,
        deactivated: 'subscription.status.deactivated.description'.tr,
      }[this]!;

  @override
  String toString() => {
        waitingProof: 'subscription.status.waiting_proof'.tr,
        verifingProof: 'subscription.status.verifing_proof'.tr,
        proofRejected: 'subscription.status.proof_rejected'.tr,
        activate: 'subscription.status.activate'.tr,
        expired: 'subscription.status.expired'.tr,
        deactivated: 'subscription.status.deactivated'.tr,
      }[this]!;
}
