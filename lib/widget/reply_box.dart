import 'package:flutter/material.dart';

class ReplyBox extends StatelessWidget {
  final Function onPressed;

  final String hintText;

  final String initValue;

  ReplyBox(this.onPressed, this.hintText, {this.initValue});

  final TextEditingController _editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _editingController.text = this.initValue;
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.1),
      ),
      child: new IconTheme(
          data: new IconThemeData(color: Theme.of(context).accentColor),
          child: new Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(children: <Widget>[
                new Flexible(
                    child: new TextField(
                  controller: _editingController,
                  autofocus: true,
                  maxLines: 10,
                  minLines: 1,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(hintText: hintText),
                )),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () => onPressed(_editingController.text)),
                )
              ]))),
    );
  }

  void _handleSubmitted(String value) {}
}
