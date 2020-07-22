import 'package:flutter/material.dart';

class Like extends StatelessWidget {
  final bool liked;
  final int likeCount;

  final Function onPress;

  Like(this.liked, this.likeCount, this.onPress);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(padding: EdgeInsets.all(2), child:  Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: !liked
                ? const Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 20,
            )
                : const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
            child: Text(
              '+$likeCount',
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return FlatButton.icon(
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//      onPressed: onPress,
//      icon: !liked
//          ? const Icon(
//              Icons.favorite_border,
//              color: Colors.grey,
//            )
//          : const Icon(
//              Icons.favorite,
//              color: Colors.red,
//            ),
//      label: Text(
//        '+$likeCount',
//        style: Theme.of(context).textTheme.caption,
//      ),
//    );
//  }
}
