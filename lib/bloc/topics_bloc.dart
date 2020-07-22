import 'package:rc/model/topic.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchTopics {
  String type;

  int nodeId;

  int limit;

  int offset;

  FetchTopics(this.type, this.nodeId, this.limit, this.offset);
}

class TopicsBloc {
  Stream<List<Topic>> _topics = Stream.empty();

  Stream<List<Topic>> get topics => _topics;

  final _actionSubject = BehaviorSubject<dynamic>();



  void fetchTopics(FetchTopics params) {
    _actionSubject.sink.add(params);
  }

  TopicsBloc() {
    _topics = Observable(_actionSubject.stream)
        .ofType(TypeToken<FetchTopics>())
        .asyncMap((_) => getTopics(_).then(_mapResponse))
        .asBroadcastStream();
  }

  Future<http.Response> getTopics(FetchTopics params) {
    String url =
        "https://ruby-china.org/api/v3/topics.json?limit=${params.limit}&offset=${params.offset}";
    if(params.type != null) {
      url += "&type=${params.type}";
    }
    if(params.nodeId != null) {
      url += '&node_id=${params.nodeId}';
    }
    return http.get(url);
  }

  List<Topic> _mapResponse(http.Response ret) {
    if (ret.body.isEmpty) {
      return [];
    }
    List<Topic> _topics = json
        .decode(ret.body)['topics']
        .map<Topic>((v) => Topic.fromJson(v))
        .toList();
    return _topics;
  }

  void dispose() {
    _actionSubject.close();
  }
}
