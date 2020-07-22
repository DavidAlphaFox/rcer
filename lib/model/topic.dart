import 'package:rc/utils.dart';
import 'topic_detail.dart';
import 'topic_abilities.dart';

import 'user.dart';

class Topic {
  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime repliedAt;
  int repliesCount;
  String nodeName;
  int nodeId;
  int lastReplyUserId;
  String lastReplyUserLogin;
  String grade;
  int likesCount;
  DateTime suggestedAt;
  DateTime closedAt;
  bool deleted = false;
  User user;
  int excellent;
  int hits;
  bool closed;
  TopicAbilities abilities;

  Topic.simple(int id, String title) : this.id = id, this.title = title;

  Topic.fromJson(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.createdAt = Utils.parseDate(json['created_at']),
        this.updatedAt = json['created_at'] == null
            ? null
            : Utils.parseDate(json['updated_at']),
        this.repliedAt = json['replied_at'] == null
            ? null
            : Utils.parseDate(json['replied_at']),
        this.nodeId = json['node_id'],
        this.nodeName = json['node_name'],
        this.lastReplyUserId = json['last_reply_user_id'],
        this.lastReplyUserLogin = json['last_reply_user_login'],
        this.likesCount = json['likes_count'],
        this.repliesCount = json['replies_count'],
        this.grade = json['grade'],
        this.suggestedAt = json['suggestedAt'] == null
            ? null
            : Utils.parseDate(json['suggestedAt']),
        this.closedAt = json['closed_at'] == null
            ? null
            : Utils.parseDate(json['closed_at']),
        this.closed = json['closed_at'] != null,
        this.deleted = json['deleted'],
        this.excellent = json['excellent'],
        this.hits = json['hits'],
        this.user = User.fromJson(json['user']),
        this.abilities = TopicAbilities.fromJson(json['abilities']);

  Topic.fromDetail(TopicDetail detail)
      : this.id = detail.id,
        this.title = detail.title,
        this.createdAt = detail.createdAt,
        this.user = detail.user;

  @override
  String toString() {
    return 'Topic{id: $id, title: $title}';
  }
}
