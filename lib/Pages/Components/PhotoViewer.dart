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
    // TODO: implement initState
    super.initState();
    nowPosition = initialPage;
    pageController = PageController(initialPage: initialPage);
    _initData();
  }

  void _initData() {
    dotWidgets = [];
    if (widget.imageList.length > 1) {
      for (int i = 0; i < widget.imageList.length; i++) {
        dotWidgets.add(_buildDots(i));
      }
    }
  }

  Widget _buildDots(int index) => Container(
        margin: EdgeInsets.all(5),
        child: ClipOval(
          child: Container(
            color: index == nowPosition
                ? widget.checkedColor
                : widget.uncheckedColor,
            width: 5.0,
            height: 5.0,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
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
                  nowPosition = index;
                  _initData();
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
              margin: EdgeInsets.only(bottom: 10),
              child: Wrap(
                children: dotWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
}
