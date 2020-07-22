import 'package:http/http.dart' as http;
import 'http_method.dart';
import 'package:rc/constants.dart';
import 'package:rc/http/token_manager.dart';
import 'package:rc/model/token.dart';

class HttpUtil {

  static Future<http.Response> execute(url,
      {Map<String, Object> params = const {}, HttpMethod method = HttpMethod.GET}) async {
    Map<String, String> body =
        params.map((k, v) => MapEntry<String, String>(k, '$v'));

    Map<String, String> headers = {};
    Token token = await TokenManager.instance.getToken();
    if(token != null) {
      headers['Authorization'] = '${token.tokenType} ${token.accessToken}';
    }

    Future<http.Response> res;
    switch (method) {
      case HttpMethod.GET:
        res = http.get(_handleUrl(url, params: body), headers: headers);
        break;
      case HttpMethod.POST:
        res = http.post(url, body: body, headers: headers);
        break;
      case HttpMethod.PUT:
        res = http.put(url, body: body, headers: headers);
        break;
      case HttpMethod.DELETE:
        res = http.delete(_handleUrl(url, params: body), headers: headers);
        break;
    }

    if(DEBUG_MODE) {
      http.Response response = await res;
      print('http request, method:$method, url: $url, params: $params result: ${response.body}');
    }
    return res;
  }

  static String _handleUrl(String url, {Map<String, Object> params}) {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    return url;
  }
}
