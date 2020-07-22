import 'package:rc/utils.dart';

import 'user.dart';
import 'meta.dart';
import 'topic_abilities.dart';

class TopicDetail{
  int id;
  String title;
  DateTime createdAt;
  int likesCount;
  String body;
  String bodyHtml;
  User user;
  Meta meta;
  bool closed;
  TopicAbilities abilities;

  TopicDetail.fromJson(Map json, Map metaMap)
      : this.id = json['id'],
        this.title = json['title'],
        this.likesCount = json['likes_count'],
        this.createdAt = Utils.parseDate(json['created_at']),
        this.body = json['body'],
        this.user = User.fromJson(json['user']),
        this.closed = json['closed_at'] != null,
        this.bodyHtml = json['body_html'],
        this.abilities = TopicAbilities.fromJson(json['abilities']),
        this.meta = Meta.fromJson(metaMap);

  TopicDetail.empty()
      : this.title = '',
        this.body = 'Not Found';



  @override
  String toString() {
    return 'TopicDetail{id: $id, title: $title, createdAt: $createdAt, body: $body, user: $user}';
  }


}
