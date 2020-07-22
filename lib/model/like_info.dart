class LikeInfo {
  String objectType;
  int objId = -1;
  int count = 0;

  LikeInfo.fromJson(json)
      : this.objectType = json['object_type'],
        this.objId = json['obj_id'],
        this.count = json['count'];
}
