import '../utils.dart';

class Node {
  int id;
  String name;
  int topicsCount;
  String summary;
  int sectionId;
  String sectionName;
  int sort;
  DateTime updatesAt;

  Node.fromJson(json)
      : this.id = json['id'],
        this.name = json['name'],
        this.topicsCount = json['topics_count'],
        this.summary = json['summary'],
        this.sectionId = json['section_id'],
        this.sectionName = json['section_name'],
        this.sort = json['sort'],
        this.updatesAt = Utils.parseDate(json['updated_at']);
}
