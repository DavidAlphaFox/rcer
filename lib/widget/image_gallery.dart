import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;

  String initUrl;


  ImageGallery(this.imageUrls, this.initUrl , {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageGallery();
  }
}

class _ImageGallery extends State<ImageGallery> {
  int _curPage = 1;


  PageController _pageController;

  @override
  void initState() {
    super.initState();
    final List<String> urls = widget.imageUrls;
    final initPage = widget.initUrl != null ? urls.indexOf(widget.initUrl) : 0;
    _curPage = initPage + 1;
    _pageController = PageController(initialPage: initPage);
  }

  void _onPageChanged(int index) {
    setState(() {
      _curPage = index + 1;
    });
  }


  @override
  Widget build(BuildContext context) {

    List<PhotoViewGalleryPageOptions> options = _buildGalleryItems(widget.imageUrls);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('查看图片'),
        ),
        body: Stack(
          children: <Widget>[
            PhotoViewGallery(
                pageController: _pageController,
                onPageChanged: _onPageChanged,
                backgroundDecoration: BoxDecoration(color: Colors.black),
                pageOptions: options),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "$_curPage/${options.length}",
                style: const TextStyle(
                    color: Colors.white, fontSize: 17.0, decoration: null),
              ),
            )
          ],
        ));
  }

  List<PhotoViewGalleryPageOptions> _buildGalleryItems(List<String> urls) {
    List<PhotoViewGalleryPageOptions> options = [];
    int totalSize = urls.length;
    for (int i = 0; i < totalSize; i++) {
      options.add(PhotoViewGalleryPageOptions(
          heroTag: '${i + 1}/$totalSize',
          imageProvider: CachedNetworkImageProvider(urls[i])));
    }

    return options;
  }
}
