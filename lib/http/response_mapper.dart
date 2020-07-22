//import 'package:http/http.dart' as htttp;
//import 'dart:convert';
//import 'package:rc/http/result.dart';
//
//abstract class ResponseMapper<T> {
//  T map(htttp.Response response);
//}
//
//class DefaultResponseMapper<Result<Object>> {
//
//
//  @override
//  Result<T> map(htttp.Response response) {
//    int statusCode = response.statusCode;
//    Map map = {};
//    String error;
//    if (response.body != null && response.body.isNotEmpty) {
//      map = json.decode(response.body);
//      error = map['error'];
//    }
//    Result<T> result;
//    switch (statusCode) {
//      case 200:
//      case 201:
//        result = Result<T>(isOk: true, data: callback(map));
//        break;
//      case 400:
//        result = Result<T>(
//            isOk: false, error: map['RecordInvalid'], message: map['message']);
//        break;
//      case 401:
//        if ('invalid_grant' == error) {
//          result = result = Result<T>(
//              isOk: false, error: error, message: map['error_description']);
//        } else {
//          result = Result<T>(isOk: false, error: error, message: '请重新登录');
//        }
//        break;
//      case 403:
//        result = Result<T>(isOk: false, message: '当前用户对资源没有操作权限');
//        break;
//      case 404:
//        result = Result<T>(isOk: false, message: '资源不存在');
//        break;
//      case 500:
//        result = Result<T>(isOk: false, message: '服务器异常');
//        break;
//    }
//
//    return result;
//  }
//
//
//}