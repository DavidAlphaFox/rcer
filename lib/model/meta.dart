class Meta {
  bool followed = false;
  bool liked = false;
  bool favorited = false;

  Meta.fromJson(json)
      : this.followed = json['followed'],
        this.favorited = json['favorited'],
        this.liked = json['liked'];
}
