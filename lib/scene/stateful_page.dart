import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget{

  final Widget child;

  KeepAliveWidget({Key key, @required this.child}):super(key: key);

  @override
  State<StatefulWidget> createState()  => _KeepAliveWidgetState();

}

class _KeepAliveWidgetState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin{



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;

}