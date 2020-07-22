import 'package:rc/model/user.dart';
import 'package:rc/model/reply.dart';
import 'package:rc/model/topic.dart';
import '../utils.dart';

class Notification {
  int id;
  String type;
  bool read = false;
  User actor;
  String mentionType;
  DateTime createdAt;
  DateTime updatedAt;
  Reply reply;
  Topic topic;

  Notification.fromJson(json)
      : this.id = json['id'],
        this.type = json['type'],
        this.read = json['read'],
        this.actor = User.fromJson(json['actor']),
        this.reply = json['reply'] == null ? null : Reply.fromJson(json['reply']),
        this.topic = Topic.fromJson(json['topic']),
        this.createdAt = Utils.parseDate(json['created_at']),
        this.updatedAt = Utils.parseDate(json['updated_at']);
}
