import 'dart:convert';
class Token {

  String accessToken;

  String refreshToken;

  String tokenEndpoint;

  List<String> scope;

  String tokenType;

  int expiration;

  int createdAt;

  //200{"access_token":"8d6599d521a560d25e7f9c7833a30b5b06d1987d06ce072bfc2c35da647d9c5f","token_type":"Bearer","expires_in":86400,"refresh_token":"b8b5dbdc9591c272d015daf08bf2f9c0ab740e9917b1a63048e389c98a71cfa8","created_at":1554290135}

  Token.fromJson2(json)
      : this.accessToken = json['access_token'],
        this.refreshToken = json['refresh_token'],
        this.scope = json['scope'],
        this.tokenType = json['token_type'],
        this.createdAt = json['created_at'],
        this.expiration = json['expires_in'];

  Token.fromJson(json) : this.accessToken = json['accessToken'],
        this.refreshToken = json['refreshToken'],
        this.scope = json['scope'],
        this.tokenType = json['tokenType'],
        this.createdAt = json['createdAt'],
        this.expiration = json['expiration'];


  bool get expired => ((this.expiration + this.createdAt) * 1000) < DateTime.now().millisecondsSinceEpoch;


  @override
  String toString() {
    return '{accessToken: $accessToken, refreshToken: $refreshToken, tokenEndpoint: $tokenEndpoint, scope: $scope, tokenType: $tokenType, expiration: $expiration, createdAt: $createdAt}';
  }

  String toJsonStr() {
    Map<String, Object> map = {};
    map['accessToken'] = this.accessToken;
    map['refreshToken'] = this.refreshToken;
    map['tokenEndpoint'] = this.tokenEndpoint;
    map['scope'] = this.scope;
    map['tokenType'] = this.tokenType;
    map['expiration'] = this.expiration;
    map['createdAt'] = this.createdAt;
    return json.encode(map);
  }

}
