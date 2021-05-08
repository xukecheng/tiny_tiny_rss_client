import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../Pages/Components/PhotoViewer.dart';

class ImageClickWidgetFactory extends WidgetFactory {
  ImageClickWidgetFactory({@required this.context});
  final context;
  List imageList = [];
  @override
  Widget? buildImage(BuildMetadata meta, ImageMetadata image) {
    final built = super.buildImage(meta, image);
    if (built == null) return built;
    imageList.add(image.sources.first.url);
    return GestureDetector(
      child: Hero(
        tag: image.sources.first.url,
        child: built,
      ),
      onTap: () {
        // 跳转到图片预览页
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewer(
              this.imageList,
              initialPage: imageList.indexOf(image.sources.first.url),
            ),
          ),
        );
      },
    );
  }
}
