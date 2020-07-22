import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rc/widget/markdown/syntax_highlighter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rc/widget/image_gallery.dart';
import 'package:rc/scene/user_info_scene.dart';
import 'package:rc/model/user.dart';
import 'package:rc/routes_helper.dart';
import 'package:rc/constants.dart';

class MdViewer extends StatefulWidget {
  final String data;

  MdViewer({this.data});

  @override
  State<StatefulWidget> createState() {
    return MdViewerState();
  }
}

final REG = RegExp(r'@[^,，：:\s@]+');

class MdViewerState extends State<MdViewer> {
  Set<String> _imgUrls = new Set();
  Map<String, String> _userUrls = {};

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return MarkdownBody(
        styleSheet: new MarkdownStyleSheet(
          a: const TextStyle(color: Colors.blue),
          p: new TextStyle(
            color: theme.textTheme.body1.color,
            fontSize: theme.textTheme.body1.fontSize * 1.01
          ),
          code: new TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "monospace",
              fontSize: theme.textTheme.body1.fontSize
          ),
          h1: theme.textTheme.headline,
          h2: theme.textTheme.title,
          h3: theme.textTheme.subhead,
          h4: theme.textTheme.body2,
          h5: theme.textTheme.body2,
          h6: theme.textTheme.body2,
          em: const TextStyle(fontStyle: FontStyle.italic),
          strong: const TextStyle(fontWeight: FontWeight.bold),
          blockquote: theme.textTheme.body1,
          img: theme.textTheme.body1,
          blockSpacing: 8.0,
          listIndent: 32.0,
          blockquotePadding: 8.0,
          blockquoteDecoration: new BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
              borderRadius: new BorderRadius.circular(2.0)
          ),
          codeblockPadding: 8.0,
          codeblockDecoration: new BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: new BorderRadius.circular(2.0)
          ),
          horizontalRuleDecoration: new BoxDecoration(
            border: new Border(
                top: new BorderSide(width: 5.0, color: Colors.grey.shade300)
            ),
          ),
        ),
        data: _handleContent(widget.data),
        onImageDetect: (href) => _imgUrls.add(href),
//        syntaxHighlighter: DartSyntaxHighlighter(),
        onTapLink: (href) => _launchURL(context, href));
  }

  String _handleContent(String content) {
    String result = widget.data;
    //https://www.cnblogs.com/ygcool/p/8717391.html
    // http://www.cndartlang.com/778.html
    result = result.replaceAllMapped(REG, (_) => _userIndex(_.group(0)));

    return result;
  }

  String _userIndex(String source) {
    String loginId = source.substring(1);
    String url = 'https://ruby-china.org/$loginId';
    String urlMd = '[$source]($url)';
    _userUrls[url] = loginId;
    return urlMd;
  }

  void _launchURL(BuildContext context, String url) async {
    if (_imgUrls.contains(url)) {
      _showImageGallery(context, url);
      return;
    }
    if (_userUrls.containsKey(url)) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (ctx) =>
              UserInfoScene(User.fromJson({'login': _userUrls[url]}), false)));

      return;
    }

    Uri uri = Uri.parse(url);
    List pathSegments =  uri.pathSegments;
    if(uri.host == HOST_SIMPLE &&   pathSegments.length > 0) {
      if(pathSegments[0] == 'topics') {
        RoutesHelper.of(context).goTopicDetail(int.parse(pathSegments[1]), '');
        return;
      }
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showImageGallery(BuildContext context, String url) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (ctx) => ImageGallery(_imgUrls.toList(), url)));
  }
}
