import 'package:flutter/material.dart';
import 'routes.dart';

import 'package:rc/scene/user_login_scene.dart';
import 'package:rc/scene/settings.dart';
import 'package:rc/scene/user_topics_scene.dart';
import 'package:rc/model/user.dart';
import 'package:rc/scene/user_info_scene.dart';
import 'package:rc/scene/user_users_scene.dart';
import 'package:rc/scene/user_replies_scene.dart';
import 'package:rc/model/topic.dart';
import 'package:rc/scene/topic_scene.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rc/scene/add_topic_scene.dart';

class RoutesHelper {
  final BuildContext context;

  RoutesHelper(this.context);

  void goLogin() {
//    Navigator.pushNamed(context, RCRoutes.login);

    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (ctx) => UserLoginScene()));
  }

  void goSettings() {
    //  Navigator.pushNamed(context, RCRoutes.settings);

    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (ctx) => SettingsScene()));
  }

  static RoutesHelper of(BuildContext context) => RoutesHelper(context);

  void goAddTopic() {
//    Navigator.pushNamed(context, RCRoutes.addEditTopic);

    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (ctx) => AddTopicScene()));
  }

  void goUserTopics(String login, String type) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx) => UserTopicsScene(
              loginId: login,
              type: type,
            )));
  }

  void goUserUsers(String login, String type) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx) => UserUsersScene(
              loginId: login,
              type: type,
            )));
  }

  void goUserInfo(User user, bool isSelf) {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (ctx) => UserInfoScene(user, isSelf)));
  }

  void goUserReplies(String login) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx) => UserRepliesScene(
              loginId: login,
            )));
  }

  void goTopicDetail(int topicId, String topicTitle) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx) => TopicScene(Topic.simple(topicId, topicTitle))));
  }

  void launchURL(BuildContext context, String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
