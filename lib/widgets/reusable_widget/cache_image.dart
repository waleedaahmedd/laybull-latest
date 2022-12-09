// import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CacheImage extends StatefulWidget {
  String? imageUrl;
  double? height;
  double? width;
  double? radius;

  CacheImage({
    this.imageUrl,
    this.height = 35,
    this.width = 35,
    this.radius = 0,
    Key? key,
  }) : super(key: key);
  @override
  _CacheImageState createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.radius!),
        ),
        child: CachedNetworkImage(
          height: widget.height,
          width: widget.width,
          fit: BoxFit.contain,
          imageUrl: widget.imageUrl!,
          placeholder: (context, url) => Center(
            child: Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.all(5),
              child: const CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ));
  }
}
