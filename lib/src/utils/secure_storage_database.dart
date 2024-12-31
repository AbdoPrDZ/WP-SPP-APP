import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_database/storage_database.dart';

import '../src.dart';

class SecureStorageDatabase extends StorageDatabaseSource {
  final SharedPreferences storage;
  final String password;

  SecureStorageDatabase(this.storage, {required this.password});

  static Future<SecureStorageDatabase> get instance async {
    final deviceId = await getDeviceId();

    return SecureStorageDatabase(await SharedPreferences.getInstance(),
        password: deviceId.padRight(32));
  }

  static encrypt.IV iv = encrypt.IV.fromUtf8("SPP HOSTS APP 25");

  static encrypt.Encrypter encrypter(String password) => encrypt.Encrypter(
        encrypt.AES(
          encrypt.Key.fromUtf8(password.padLeft(32)),
          mode: encrypt.AESMode.cbc,
        ),
      );

  static String encryptData(String data, String password) =>
      encrypter(password).encrypt(data, iv: iv).base64;

  static String decryptData(String crypto, String password) =>
      encrypter(password).decrypt(encrypt.Encrypted.fromBase64(crypto), iv: iv);

  Future<Map> get _data async {
    String? data = storage.getString('data');

    return data != null ? jsonDecode(decryptData(data, password)) : {};
  }

  Future<bool> _setData(Map data) => storage.setString(
        'data',
        encryptData(jsonEncode(data), password),
      );

  @override
  Future<bool> setData(String id, dynamic data) async {
    Map sData = await _data;

    sData[id] = data;

    return await _setData(sData);
  }

  @override
  Future<dynamic> getData(String id) async => (await _data)[id];

  @override
  Future<bool> containsKey(String id) async => (await _data).containsKey(id);

  @override
  Future<bool> remove(String id) async {
    final data = await _data;

    data.remove(id);

    return await _setData(data);
  }

  @override
  Future<bool> clear() async {
    final data = await _data;

    data.clear();

    return await _setData(data);
  }
}
