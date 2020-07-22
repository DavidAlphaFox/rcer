import 'dart:io';

import 'package:rc/service/result.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef void DataLoaderCallBack<T>(Result<T> result);
typedef Future<Result<T>> Loader<T>();

class DataLoader<T> {
  final BuildContext context;

  DataLoader(this.context);

  static DataLoader of<T>(BuildContext context) => DataLoader<T>(context);

  void load<T>(Loader<T> loader,
      {DataLoaderCallBack<T> onSuccess,
      DataLoaderCallBack<T> onFail,
      Function showDialog}) {
    if (showDialog != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: _LoadingDialog(
            text: '请稍候',
          ));
    }

    loader()
        .then((res) {
          if (showDialog != null) {
            Navigator.pop(context);
          }

          if (res.isOk) {
            if (onSuccess != null) {
              onSuccess(res);
            }
          } else {
            if (onFail != null) {
              onFail(res);
            } else {
              Fluttertoast.showToast(msg: res.message);
            }
          }
        })
        .whenComplete(() {})
        .timeout(Duration(seconds: 30))
        .catchError((e) {
          if (e is SocketException) {
            Fluttertoast.showToast(msg: e.toString());
          } else {
            throw e;
          }
        });
  }
}

class _LoadingDialog extends Dialog {
  String text;

  _LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new Container(
          width: 120.0,
          height: 120.0,
          child: Card(
            child: new Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      text,
                      style: new TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
