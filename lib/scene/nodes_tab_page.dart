// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rc/scene/topics_scene.dart';
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  // Wraps a list of chips into a ListTile for display as a section in the demo.
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: new Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
        child: new Text(label, textAlign: TextAlign.start),
      ),
      subtitle: children.isEmpty
          ? new Center(
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  '...',
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            )
          : new Wrap(
              children: children
                  .map((Widget chip) => new Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: chip,
                      ))
                  .toList(),
            ),
    );
  }
}

class NodePage extends StatefulWidget {
  @override
  _ChipDemoState createState() => new _ChipDemoState();
}

class Section {
  int id;
  String name;

  Section(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Section && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class _ChipDemoState extends State<NodePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var dataList = [];

  var _farvirateNodes = [];

  Future<String> loadNodes() async {
    return await rootBundle.loadString('conf/nodes.json', cache: true);
  }

  _ChipDemoState() {
    loadNodes().then((value) {
      JsonDecoder decoder = new JsonDecoder();
      Map<String, dynamic> map = decoder.convert(value);
      List nodes = map['nodes'];

      _loadFarvirateNodes().then((value) {
        var favNodes = [];
        if (value != null) {
          favNodes = json.decode(value);
        }
        setState(() {
          dataList = nodes;
          _farvirateNodes = favNodes;
        });
      });
    });
  }

  Future<String> _loadFarvirateNodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("nodes");
  }

  _saveFarvirateNodes(item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_farvirateNodes.contains(item)) {
      _farvirateNodes.add(item);
      prefs.setString("nodes", json.encode(_farvirateNodes));
      setState(() {
        _farvirateNodes = _farvirateNodes;
      });
    }
  }

  _removeFarvirateNode(item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_farvirateNodes.contains(item)) {
      _farvirateNodes.remove(item);
      prefs.setString("nodes", json.encode(_farvirateNodes));
      setState(() {
        _farvirateNodes = _farvirateNodes;
      });
    }

  }

  String _capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  void showSumarDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text('You selected: $value')));
      }
    });
  }



  Widget buildFavChip(item) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
    theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text("简介"),
                content: Text(item['summary'], style: dialogTextStyle),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('移除'),
                      onPressed: () {
                        _removeFarvirateNode(item);
                        Navigator.of(context).pop(context);
                      })
                ]));
      },
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (ctx) => Scaffold(
              appBar: new AppBar(title: Text(item['name'])),
              body: TopicsScene(nodeId: item['id'], showNodeButton: false,),
            )));
      },
      child: new Chip(
        key: new ValueKey<String>(item['name']),
        label: new Text(_capitalize(item['name'])),
      ),
    );
  }



  Widget buildChip(item) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text("简介"),
                    content: Text(item['summary'], style: dialogTextStyle),
                    actions: <Widget>[
                      new FlatButton(
                          child: const Text('收藏'),
                          onPressed: () {
                            _saveFarvirateNodes(item);
                            Navigator.of(context).pop(context);
                          })
                    ]));
      },
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (ctx) => Scaffold(
                  appBar: new AppBar(title: Text(item['name'])),
                  body: TopicsScene(nodeId: item['id'], showNodeButton: false,),
                )));
      },
      child: new Chip(
        key: new ValueKey<String>(item['name']),
        label: new Text(_capitalize(item['name'])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];

    Map<Section, List<Widget>> fx = {};

    Section section = new Section(-999, "我的收藏");

    if (!fx.containsKey(section)) {
      fx[section] = [];
    }

    for (var item in _farvirateNodes) {
      fx[section].add(buildFavChip(item));
    }

    for (var item in dataList) {
      Section section = Section(item['section_id'], item['section_name']);
      if (!fx.containsKey(section)) {
        fx[section] = [];
      }
      fx[section].add(buildChip(item));
    }

    for (Section section in fx.keys) {
      final List<Widget> xx = <Widget>[
        const SizedBox(height: 1.0, width: 0.0),
        new _ChipsTile(label: section.name, children: fx[section]),
      ];

      tiles.addAll(xx);
    }

    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('节点'),
      ),
      body: new ChipTheme(
        data: theme.chipTheme,
        child: new ListView(children: tiles),
      ),
    );
  }
}
