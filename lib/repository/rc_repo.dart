import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:rc/model/models.dart';
import 'package:rc/constants.dart';



class RCRepo {
  // api地址
  final String API_URL = 'https://ruby-china.org/api/v3/';




  // 获取回复列表
  Future<List<Reply>> getReplies(int topicId, int limit, int offset) async {
    String url = '${API_URL}topics/$topicId/replies.json';
    String res = await _get(url, params: {
      'limit': '$limit',
      'offset': '$offset',
    });
    Map map = json.decode(res);
    List likedIds = map['meta']['user_liked_reply_ids'];
    List<Reply> replies = map['replies'].map<Reply>((v) {
      Reply tmp = Reply.fromJson(v);
      tmp.liked = likedIds.contains(tmp.id);
      return tmp;
    }).toList();

    return replies;
  }


//  // 删除回帖
//  Future<bool> delReply(int id) async {
//    String url = '${API_URL}replies/$id.json';
//    String res = await _delete(url);
//    return 1 == json.decode(res)['ok'];
//  }
//
//  // 删除回帖
//  // 回复话题
//  Future<Reply> updateReply(int id, String body, {int replyToId}) async {
//    String url = '${API_URL}replies/$id.json';
//    Map<String, String> params = {'body': body};
//    if (replyToId != null) {
//      params['reply_to_id'] = '$replyToId';
//    }
//    String res = await _post(url, params: params);
//    Reply reply = Reply.fromJson(json.decode(res)['reply']);
//    reply.liked = false;
//    return reply;
//  }
//
//  // 回复话题
//  Future<Reply> reply(int id, String body, {int replyToId}) async {
//    String url = '${API_URL}topics/$id/replies.json';
//    Map<String, String> params = {'body': body};
//    if (replyToId != null) {
//      params['reply_to_id'] = '$replyToId';
//    }
//    String res = await _post(url, params: params);
//    Reply reply = Reply.fromJson(json.decode(res)['reply']);
//    reply.liked = false;
//    return reply;
//  }
//






  // 设置通知已读
  Future<void> setNotificationsRead(List<int> ids) async {
    String url = '${API_URL}notifications/read.json';

    String arr = json.encode(ids);
    _post(url, params: {'ids[]': '{$arr}'});
  }

  // 删除通知
  Future<void> delNotification(int id) async {
    String url = '${API_URL}notifications/$id.json';
    _delete(url);
  }

  // 清空通知
  Future<void> clearNotification(int id) async {
    String url = '${API_URL}notifications/all.json';
    _delete(url);
  }

  Future<String> _getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String res = pref.getString(SP_KEY_TOKEN);
    Token token;
    if(res != null) {
      token = Token.fromJson(json.decode(res));
    } else {
      return null;
    }
    return token.accessToken;
  }


  Future<String> _get(String url,
      {Map<String, String> params, bool withToken = true}) async {
    if (params == null) {
      params = {};
    }
    if (withToken) {
      params['access_token'] = await _getToken();
    }
    http.Response res = await http.get(_handleUrl(url, params: params));
    return res.body;
  }

  Future<String> _post(String url,
      {Map<String, String> params, bool withToken = true}) async {
    if (params == null) {
      params = {};
    }
    if (withToken) {
      params['access_token'] = await _getToken();
    }


    http.Response res = await http.post(url, body: params);
    String body = res.body;
    return body;
  }

  Future<String> _delete(String url,
      {Map<String, Object> params, bool withToken = true}) async {
    if (params == null) {
      params = {};
    }
    if (withToken) {
      params['access_token'] = await _getToken();
    }
    http.Response res = await http.delete(_handleUrl(url, params: params));
    return res.body;
  }

  String _handleUrl(String url, {Map<String, Object> params}) {
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






