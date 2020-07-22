import 'user.dart';
import 'reply_abilities.dart';
import '../utils.dart';
import 'topic.dart';


class Reply {
  int id;
  String bodyHtml;
  String body;
  int topicId;
  DateTime createdAt;
  DateTime updatedAt;
  int likesCount;
  bool liked;
  String action;
  String topicTitle;
  String targetType;
  Topic mentionTopic;
  bool deleted;

  User user;

  ReplyAbilities abilities;

  Reply.fromJson(json)
      : this.id = json['id'],
        this.bodyHtml = json['body_html'],
        this.body = json['body'],
        this.topicId = json['topic_id'],
        this.createdAt = Utils.parseDate(json['created_at']),
        this.updatedAt = Utils.parseDate(json['updated_at']),
        this.likesCount = json['likes_count'],
        this.deleted = json['deleted'],
        this.user = User.fromJson(json['user']),
        this.action = json['action'],
        this.topicTitle = json['topic_title'],
        this.targetType = json['target_type'],
        this.mentionTopic = json['mention_topic'] == null ? null : Topic.fromJson(json['mention_topic']) ,
        this.abilities = ReplyAbilities.fromJson(json['abilities']);
}
