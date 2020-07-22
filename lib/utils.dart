import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static DateFormat _parser = DateFormat("yyyy-MM-ddTHH:mm:ss");
  static DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  static DateTime parseDate(String input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    return _parser.parse(input);
  }

  static String format(DateTime input) {
    return _format.format(input);
  }

  static const MethodChannel _channel =
      const MethodChannel('clipboard_manager');

  static Future<void> copyToClipBoard(String text) async {
    Clipboard.setData(ClipboardData(text: text));
  }

  static void launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
