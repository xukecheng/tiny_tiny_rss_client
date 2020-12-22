import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewer extends StatefulWidget {
  ///图片Lst
  final List imageList;

  ///初始展示页数。默认0
  final int initialPage;

  ///选中的页的点的颜色
  final Color checkedColor;

  ///未选中的页的点的颜色
  final Color uncheckedColor;

  PhotoViewer(this.imageList,
      {this.initialPage = 0,
      this.checkedColor = Colors.white,
      this.uncheckedColor = Colors.grey});

  @override
  _PhotoViewerState createState() =>
      _PhotoViewerState(initialPage: initialPage);
}

class _PhotoViewerState extends State<PhotoViewer> {
  PageController pageController;
  int nowPosition;
  int initialPage;
  List<Widget> dotWidgets;

  _PhotoViewerState({this.initialPage = 0});

  @override
  void initState() {
    super.initState();
    nowPosition = initialPage + 1;
    pageController = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    int imageNum = widget.imageList.length;
    return Container(
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          // 向下垂直滑动关闭预览
          if (details.delta.dy > 0) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              onPageChanged: (index) {
                setState(() {
                  nowPosition = index + 1;
                });
              },
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.imageList[index]),
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.imageList[index]),
                );
              },
              itemCount: widget.imageList.length,
              pageController: pageController,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Text(
                '$nowPosition / $imageNum',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
