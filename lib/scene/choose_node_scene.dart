import 'package:flutter/material.dart';
import 'package:rc/model/node.dart';
import 'package:rc/service/service.dart';

class ChooseNodeScene extends StatefulWidget {

  Function onNodeSelected;


  ChooseNodeScene(this.onNodeSelected);

  @override
  State<StatefulWidget> createState() {
    return _ChooseNodeState();
  }
}

class _ChooseNodeState extends State<ChooseNodeScene> {
  List<Section> _sections = [];
  Map<Section, List<Node>> _data = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RCService rcService = new RCService();
    rcService.getNodesFromLocal().then((nodes) {
      Map<Section, List<Node>> data = {};

      nodes.forEach((node) {
        Section section = new Section(node.sectionId, node.sectionName);
        List<Node> children = data[section];
        if (children == null) {
          children = [];
        }
        children.add(node);
        data[section] = children;
      });

      setState(() {
        _data = data;
        _sections = _data.keys.toList();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('选择节点'),
      ),
      body: _data.isEmpty
          ? _loading()
          : ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Container(
                    child: Text(
                      _sections[index].name,
                    ),
                  ),
                  children: _buildChildrenRow(_data[_sections[index]]),
                );
              }),
    );
  }

  List<Widget> _buildChildrenRow(List<Node> nodes) {
    return List.of(nodes.map((node) => ListTile(
          onTap: () {
            widget.onNodeSelected(node);
            Navigator.of(context).pop();
          },
          title: InkWell(
            child: Text(node.name),
          ),
        )));
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(strokeWidth: 2.0),
    );
  }
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
