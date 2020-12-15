import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewer extends StatelessWidget {
  final imageUrl;
  const PhotoViewer({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          imageUrl,
        ),
      ),
    );
  }
}
