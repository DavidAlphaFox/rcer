import 'package:flutter/material.dart';
import 'package:rc/model/user_detail.dart';
class BasicInfo extends StatelessWidget {

  final UserDetail userDetail;


  BasicInfo(this.userDetail);

  @override
  Widget build(BuildContext context) {
    if(userDetail == null) {
      return Center(
        child: Text('信息为空'),
      );
    }
    return ListView(
      children: <Widget>[
        ListTile(subtitle: Text('用户名'),)
      ],
    );
  }

}