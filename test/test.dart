void main() {

  String str = "010-88888888";
  print(str.replaceAllMapped(r"^0[1-9]\d-\d{8}$", (_)=>'电话号码:${_.group(0)}'));
  // new RegExp(r'e');
  print(str.replaceAllMapped(RegExp(r"^0[1-9]\d-\d{8}$"), (_)=>'电话号码:${_.group(0)}'));


  print('@Rei 将通知设为已读没有生效。另外@Rei unread_count 和read==fals'
      'e的数目对不上'
      .replaceAllMapped(RegExp(r'@[^,，：:\s@]+'),
          (_) => '[${_.group(0)}](https://ruby-china.org/${_.group(0)})'));
}
