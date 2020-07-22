import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rc/model/user.dart';
import 'package:rc/scene/user_info_scene.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  VoidCallback onTap;
  final double size;

  UserAvatar(this.user, {this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? onTap
          : () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (ctx) => UserInfoScene(user, false))),
      child: Container(
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.avatarUrl),
        ),
      ),
    );
  }
}
