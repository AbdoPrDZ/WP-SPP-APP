import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../src.dart';

class AppUserModel {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? description;
  final String? profilePhotoUrl;

  const AppUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.profilePhotoUrl,
  });

  String get avatarLetters => firstName != null && lastName != null
      ? '${firstName![0]}${lastName![0]}'.toUpperCase()
      : username.substring(0, 2).toUpperCase();

  static AppUserModel fromMap(Map data) => AppUserModel(
        id: data['id'],
        email: data['email'] ?? '',
        username: data['username'] ?? '',
        firstName:
            data['first_name'].toString().isEmpty ? null : data['first_name'],
        lastName:
            data['last_name'].toString().isEmpty ? null : data['last_name'],
        description:
            data['description'].toString().isEmpty ? null : data['description'],
        profilePhotoUrl: data['profile_photo_url'],
      );

  static MainService get mainService => Get.find();

  static Future<AppUserModel?> get(String token) async {
    final response = await AppAPI.apiClient.get(
      AppAPI.user,
      headers: {
        ...AppAPI.headers,
        'Authorization': 'Bearer $token',
      },
    );

    final value = response.value;

    return response.statusCode == 200 && value is Map ? fromMap(value) : null;
  }
}
