import 'dart:async';

import 'package:flutter/services.dart';

class TiktokLoginFlutter {
  static const MethodChannel _channel = MethodChannel('tiktok_login_flutter');

  static Future<bool> initializeTiktokLogin(String clientKey) async {
    return await _channel.invokeMethod('initializeTiktokLogin', clientKey);
  }

  static Future<String> authorize({
    required int agencyId,
    int talentId = 0,
  }) async {
    try {
      final result = await _channel.invokeMethod('authorize', {
        "agencyId": agencyId,
        "talentId": talentId,
      });
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
