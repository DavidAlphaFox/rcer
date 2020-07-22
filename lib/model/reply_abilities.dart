class ReplyAbilities {
  bool update;
  bool destroy;

  ReplyAbilities.fromJson(json)
      : this.update = json['update'],
        this.destroy = json['destroy'];
}
