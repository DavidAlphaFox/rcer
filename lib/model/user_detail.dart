import 'user.dart';
import 'user_meta.dart';

class UserDetail {
  int id;
  String login;
  String name;
  String avatarUrl;
  String location;
  String company;
  String github;
  String twitter;
  String website;
  String bio;
  String tagLine;
  String email;
  int topicCount;
  int repliesCount;
  int followingCount;
  int followersCount;
  int favoritesCount;
  String level;
  String levelName;
  DateTime createdAt;
  UserMeta userMeta;

  UserDetail.formJson(json, meta)
      : this.id = json['id'],
        this.login = json['login'],
        this.name = json['name'],
        this.avatarUrl = json['avatar_url'],
        this.location = json['location'],
        this.company = json['company'],
        this.github = json['github'],
        this.twitter = json['twitter'],
        this.bio = json['bio'],
        this.tagLine = json['tagline'],
        this.email = json['email'],
        this.topicCount = json['topic_count'],
        this.repliesCount = json['replies_count'],
        this.followingCount = json['following_count'],
        this.followersCount = json['followers_count'],
        this.favoritesCount = json['favorites_count'],
        this.level = json['level'],
        this.levelName = json['level_name'],
        this.createdAt = DateTime.parse(json['created_at']),
        this.userMeta = UserMeta.formJson(meta);


  UserDetail.empty() : this.id = -1;

  UserDetail.fromUser(User user) {
    if (user != null) {
      this.id = user.id;
      this.login = user.login;
      this.avatarUrl = user.avatarUrl;
    } else {
      this.id = -1;
    }
  }
}
