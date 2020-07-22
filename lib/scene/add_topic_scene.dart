import 'package:flutter/material.dart';
import 'choose_node_scene.dart';
import 'package:rc/model/node.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rc/model/topic.dart';
import 'package:rc/scene/topic_scene.dart';
import 'package:rc/service/service.dart';
import 'data_loader.dart';
import 'package:rc/routes_helper.dart';

class AddTopicScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTopicScene();
  }
}

class _AddTopicScene extends State<AddTopicScene> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Node _node;
  String _title = '';
  String _content = '';

  final RCService _rcService = new RCService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增话题'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            tooltip: '保存',
            onPressed: () {
              _saveTopic(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: '标题',
                ),
                validator: (val) => val.trim().isEmpty ? '标题不能为空' : null,
                onSaved: (val) => _title = val,
              ),
              Flexible(
                child: TextFormField(
                  maxLines: null,
                  expands: true,
                  style: Theme.of(context).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: '内容',
                  ),
                  validator: (val) => val.trim().isEmpty ? '内容不能为空' : null,
                  onSaved: (val) => _content = val,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: _node == null ? Text('选择节点') : Text(_node.name),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChooseNodeScene((node) {
                                    setState(() {
                                      _node = node;
                                    });
                                  }),
                              fullscreenDialog: true,
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTopic(BuildContext context) {
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();

    if (_node == null) {
      Fluttertoast.showToast(msg: '请选择节点');
      return;
    }

    DataLoader.of(context)
        .load(() => _rcService.addTopic(_title, _content, _node.id),
            onSuccess: (res) {
      Navigator.of(context).pop();
      RoutesHelper.of(context).goTopicDetail(res.data.id, res.data.title);
    }, onFail: (res) {
      Fluttertoast.showToast(msg: res.message);
    }, showDialog: showDialog);
  }
}
