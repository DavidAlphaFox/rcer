class User {
  int id;
  String login;
  String name;
  String avatarUrl;


  User(this.id, this.login, this.name, this.avatarUrl);



  User.fromJson(Map json)
      : this.id = json['id'],
        this.login = json['login'],
        this.name = json['name'],
        this.avatarUrl = json['avatar_url'];
}
