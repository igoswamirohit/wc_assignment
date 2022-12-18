import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class CustomCircularImage extends StatelessWidget {
  const CustomCircularImage({
    Key? key,
    this.url,
    required this.size,
    this.showBorder = true,
    required this.name,
    this.isFileUploading = false,
    required this.cacheKey,
  }) : super(key: key);

  final String? url;
  final Size size;
  final bool showBorder;
  final String name;
  final bool isFileUploading;
  final String cacheKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                width: 2,
                color: Colors.blue,
              )
            : null,
      ),
      child: isFileUploading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : url != null && url!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(size.height),
                  child: CachedNetworkImage(
                    cacheKey: cacheKey,
                      key: UniqueKey(),
                      imageUrl: url!,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.red.shade900,
                          ),
                      progressIndicatorBuilder: (context, _, progress) {
                        return CircularProgressIndicator(
                          value: progress.progress,
                        );
                      }),
                )
              : Center(
                  child: Text(
                    name.characters.first,
                    style: (size.height / 3).semiBoldStyle,
                  ),
                ),
    );
  }
}
