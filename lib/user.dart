import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class User {
  static final User _singleton = User._internal();
  User._internal();
  late String deviceId;

  factory User() {
    return _singleton;
  }

  Future fetchDeviceId() async {
    if (Platform.isAndroid) {
      User().deviceId = await DeviceInfoPlugin()
          .androidInfo
          .then((value) => value.androidId!);
    } else {
      User().deviceId = await DeviceInfoPlugin()
          .iosInfo
          .then((value) => value.identifierForVendor!);
    }
  }

  String getDeviceId() {
    return User().deviceId;
  }
}
