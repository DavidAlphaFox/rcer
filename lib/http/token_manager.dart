import 'package:rc/model/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rc/constants.dart';
import 'dart:convert';
import 'package:rc/event/events.dart';
import 'package:synchronized/synchronized.dart';
import 'package:http/http.dart' as http;

class TokenManager {
  // 工厂模式
  factory TokenManager() => _getInstance();

  static TokenManager get instance => _getInstance();
  static TokenManager _instance;

  var _lock = Lock();

  TokenManager._internal();

  static TokenManager _getInstance() {
    if (_instance == null) {
      _instance = new TokenManager._internal();
    }
    return _instance;
  }

  Future<Token> getToken() async {
    Token token = await _getToken();
    if(DEBUG_MODE && token != null) {
      print('getToken ${token.toJsonStr()}');
    }

    if (token != null && token.expired) {
      await _lock.synchronized(refreshToken);
      return getToken();
    }
    return token;
  }

  Future<Token> _getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String res = sp.get(SP_KEY_TOKEN);
    Token token;

    if (res != null) {
      token = Token.fromJson(json.decode(res));
    }
    return token;
  }

  Future<void> refreshToken() async {
    Token token = await _getToken();
    if (token != null && token.expired) {
      Map<String, String> params = {};
      params['client_id'] = AUTH_CLIENT_ID;
      params['client_secret'] = AUTH_CLIENT_SECRET;
      params['refresh_token'] = token.refreshToken;
      params['grant_type'] = 'refresh_token';
      String url = AUTH_TOKEN_END_POINT;
      var response =
          await http.post(url, body: params);

      if (response.statusCode == 200) {
        token = Token.fromJson2(json.decode(response.body));

        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString(SP_KEY_TOKEN, token.toJsonStr());
      } else {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.remove(SP_KEY_TOKEN);
        EventBusManager.instance.eventBus.fire(RefreshTokenFailEvent());
      }
    }
  }
}
