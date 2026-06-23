import 'package:flutter/material.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class CommonImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const CommonImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = imageUrl.startsWith('http') || imageUrl.startsWith('https');

    Widget imageWidget;
    if (isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Icon(
            Icons.music_note_rounded,
            color: Colors.white54,
            size: width != null ? (width! * 0.4) : 24.r,
          ),
        ),
      );
    } else {
      var cleanUrl = imageUrl;
      if (imageUrl.startsWith('asset:///')) {
        cleanUrl = imageUrl.replaceFirst('asset:///', '');
      }
      imageWidget = Image.asset(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Icon(
            Icons.music_note_rounded,
            color: Colors.white54,
            size: width != null ? (width! * 0.4) : 24.r,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: imageWidget,
    );
  }
}
