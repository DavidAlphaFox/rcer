import 'dart:io';

import 'package:flutter/services.dart';
import 'package:rc/http/http.dart';
import 'package:http/http.dart' as http;
import 'result.dart';
import 'package:rc/model/models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rc/constants.dart';

typedef ResponseCallback<T>(Map map);

class RCService {
  //从本地获取所有节点
  Future<List<Node>> getNodesFromLocal() async {
    String raw = await rootBundle.loadString('conf/nodes.json', cache: true);

    List<Node> nodes =
        json.decode(raw)['nodes'].map<Node>((v) => Node.fromJson(v)).toList();

    return nodes;
  }

  // 点赞
  Future<Result<LikeInfo>> addLikes(String type, int id) async {
    String url = API_URL + 'likes';
    return _do(url,
        params: {'obj_type': type, 'obj_id': '$id'},
        method: HttpMethod.POST,
        callback: (res) => LikeInfo.fromJson(res));
  }

  // 取消点赞
  Future<Result<LikeInfo>> delLikes(String type, int id) async {
    String url = API_URL + 'likes';
    return _do(url,
        params: {'obj_type': type, 'obj_id': '$id'},
        method: HttpMethod.DELETE,
        callback: (res) => LikeInfo.fromJson(res));
  }

  // 用户话题动作
  Future<Result> userActionTopic(int id, String type) async {
    String url = '${API_URL}topics/$id/$type';
    return _do(url,
        method: HttpMethod.POST,
        callback: (res) => Result(isOk: res['ok'] == 1));
  }

  // 话题动作
  Future<Result> actionTopic(int id, String type) async {
    String url = '${API_URL}topics/$id/action';
    return _do(url,
        method: HttpMethod.POST,
        params: {'type': type},
        callback: (res) => Result(isOk: res['ok'] == 1));
  }

  // 话题动作
  Future<Result> delTopic(int id) async {
    String url = '${API_URL}topics/$id';
    return _do(url,
        method: HttpMethod.DELETE,
        callback: (res) => Result(isOk: res['ok'] == 1));
  }

  // 话题相关

  // 获取话题列表
  Future<Result<List<Topic>>> getTopics(
      {int limit, int offset, String type, int nodeId}) async {
    String url = "${API_URL}topics.json";

    Map<String, String> params = {};
    if (limit != null) {
      params['limit'] = '$limit';
    }
    if (offset != null) {
      params['offset'] = '$offset';
    }
    if (type != null && type.trim().isNotEmpty) {
      params['type'] = type;
    }
    if (nodeId != null) {
      params['node_id'] = '$nodeId';
    }

    return _do(url,
        params: params,
        method: HttpMethod.GET,
        callback: (res) =>
            res['topics'].map<Topic>((v) => Topic.fromJson(v)).toList(), withToken: false);
  }

  // 新增主题
  Future<Result<TopicDetail>> addTopic(
      String title, String body, int nodeId) async {
    String url = '${API_URL}topics.json';
    return _do(url,
        params: {'title': title, 'body': body, 'node_id': '$nodeId'},
        withToken: true,
        method: HttpMethod.POST, callback: (result) {
      Map topic = result['topic'];
      Map meta = result['meta'] == null ? {} : result['meta'];
      return TopicDetail.fromJson(topic, meta);
    });
  }

  // 回复话题

  Future<Result<Reply>> reply(int id, String body, {int replyToId}) async {
    String url = '${API_URL}topics/$id/replies.json';
    Map<String, String> params = {'body': body};
    if (replyToId != null) {
      params['reply_to_id'] = '$replyToId';
    }
    return _do(url, method: HttpMethod.POST, params: params, callback: (res) {
      Reply reply = Reply.fromJson(res['reply']);
      reply.liked = false;
      return reply;
    });
  }

  // 删除回帖
  Future<Result> delReply(int id) async {
    String url = '${API_URL}replies/$id.json';
    return _do(url,
        method: HttpMethod.DELETE,
        callback: (res) => Result(isOk: res['ok'] == 1));
  }


  Future<Result<Reply>> updateReply(int id, String body, {int replyToId}) async {
    String url = '${API_URL}replies/$id.json';
    Map<String, String> params = {'body': body};
    if (replyToId != null) {
      params['reply_to_id'] = '$replyToId';
    }
    return _do(url, method: HttpMethod.POST, params: params, callback: (res) {
      Reply reply = Reply.fromJson(res['reply']);
      reply.liked = false;
      return reply;
    });
  }

  // 获取话题详情
  Future<Result<TopicDetail>> getTopicDetail(int id) async {
    String url = '${API_URL}topics/$id.json';
    return _do(url,withToken: false, callback: (result) {
      Map topic = result['topic'];
      Map meta = result['meta'] == null ? {} : result['meta'];
      return TopicDetail.fromJson(topic, meta);
    });
  }

  // user 相关
  Future<Result<UserDetail>> getUserDetail({String loginId = 'me'}) async {
    String url = '$API_URL_USERS/$loginId.json';
    return _do(url,
        method: HttpMethod.GET,
        withToken: loginId == 'me',
        callback: (res) => UserDetail.formJson(res['user'], res['meta']));
  }

  // user 相关
  Future<Result> userUserAction(String loginId, String type) async {
    String url = '$API_URL_USERS/$loginId/$type.json';
    return _do(url,
        method: HttpMethod.POST,
        callback: (res) => (res) => Result(isOk: res['ok'] == 1));
  }

  Future<Result<List<Topic>>> getUserTopics(
      {int limit, int offset, String loginId, String type}) {
    String url = '$API_URL_USERS/$loginId/$type.json';

    Map<String, String> params = {};
    if (limit != null) {
      params['limit'] = '$limit';
    }
    if (offset != null) {
      params['offset'] = '$offset';
    }
    return _do(url,
        withToken: false,
        params: params,
        method: HttpMethod.GET,
        callback: (res) =>
            res['topics'].map<Topic>((v) => Topic.fromJson(v)).toList());
  }

  // 获取用户 屏蔽/关注/关注的人的列表
  Future<Result<List<User>>> getUserUsers(
      {int limit, int offset, String loginId, String type}) {
    String url = '$API_URL_USERS/$loginId/$type.json';

    Map<String, String> params = {};
    if (limit != null) {
      params['limit'] = '$limit';
    }
    if (offset != null) {
      params['offset'] = '$offset';
    }
    return _do(url,
        params: params,
        method: HttpMethod.GET,
        withToken: false,
        callback: (res) =>
            res[type].map<User>((v) => User.fromJson(v)).toList());
  }

  // 获取用户 屏蔽/关注/关注的人的列表
  Future<Result<List<Reply>>> getUserReplies(
      {int limit, int offset, String loginId}) {
    String url = '$API_URL_USERS/$loginId/replies.json';

    Map<String, String> params = {};
    if (limit != null) {
      params['limit'] = '$limit';
    }
    if (offset != null) {
      params['offset'] = '$offset';
    }
    return _do(url,
        params: params,
        method: HttpMethod.GET,
        withToken: false,
        callback: (res) =>
            res['replies'].map<Reply>((v) => Reply.fromJson(v)).toList());
  }

  Future<Result<Token>> login(String username, String password) async {
    Map<String, String> params = {};
    params['client_id'] = AUTH_CLIENT_ID;
    params['client_secret'] = AUTH_CLIENT_SECRET;
    params['username'] = username;
    params['password'] = password;
    params['grant_type'] = 'password';
    String url = AUTH_TOKEN_END_POINT;

    Result<Token> result = await _do(url,
        params: params,
        method: HttpMethod.POST,
        withToken: false,
        callback: (res) => Token.fromJson2(res));

    if (result.isOk) {
      await _saveToken(result.data);
    }
    return result;
  }


  Future<Result<List<Notification>>> getNotifications(
      int limit, int offset) async {
    String url = API_URL_NOTIFICATIONS;
    return _do(url,
        params: {'limit': limit, 'offset': offset},
        callback: (res) => res['notifications']
            .map<Notification>((v) => Notification.fromJson(v))
            .toList(),withToken: true);
  }

//  // 设置通知已读
//  Future<void> setNotificationsRead(List<int> ids) async {
//    String url = '${API_URL}notifications/read.json';
//
//    String arr = json.encode(ids);
//    _post(url, params: {'ids[]': '{$arr}'});
//  }


  Future<void> setNotificationsRead() async {
        String url = '${HOST_URL}notifications';
        await HttpUtil.execute(url, method: HttpMethod.GET);
  }

  Future<Result<T>> _do<T>(url,
      {Map<String, Object> params,
      HttpMethod method = HttpMethod.GET,
      ResponseCallback<T> callback,
      bool withToken = true}) async {
    if (params == null) {
      params = {};
    }



    return HttpUtil.execute(url, method: method, params: params)
        .then((res) => _mapResponse(res, callback));
  }

  Future<void> _saveToken(Token token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(SP_KEY_TOKEN, token.toJsonStr());
  }


  Result<T> _mapResponse<T>(
      http.Response response, ResponseCallback<T> callback) {
    int statusCode = response.statusCode;
    Map map = {};
    String error;
    if (response.body != null && response.body.isNotEmpty) {
      map = json.decode(response.body);
      error = map['error'];
    }
    Result result;
    switch (statusCode) {
      case 200:
      case 201:
        result = Result<T>(isOk: true, data: callback(map));
        break;
      case 400:
        result = Result<T>(
            isOk: false, error: map['RecordInvalid'], message: map['message']);
        break;
      case 401:
        if ('invalid_grant' == error) {
          result = result = Result<T>(
              isOk: false, error: error, message: map['error_description']);
        } else {
          result = Result<T>(isOk: false, error: error, message: '请重新登录');
        }
        break;
      case 403:
        result = Result<T>(isOk: false, message: '当前用户对资源没有操作权限');
        break;
      case 404:
        result = Result<T>(isOk: false, message: '资源不存在');
        break;
      case 500:
        result = Result<T>(isOk: false, message: '服务器异常');
        break;
    }

    return result;
  }
}
