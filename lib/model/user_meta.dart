class UserMeta {
  bool followed = false;
  bool blocked = false;

  UserMeta.formJson(json)
      : this.followed = json == null || json['followed'] ?? false,
        this.blocked = json == null || json['blocked'] ?? false;
}
