class TopicAbilities {
  bool update;
  bool destroy;
  bool ban;
  bool normal;
  bool excellent;
  bool unExcellent;
  bool close;
  bool open;

  TopicAbilities.fromJson(json)
      : this.update = json['update'],
        this.destroy = json['destroy'],
        this.ban = json['ban'],
        this.normal = json['normal'],
        this.excellent = json['excellent'],
        this.unExcellent = json['unexcellent'],
        this.close = json['close'],
        this.open = json['open'];
}
