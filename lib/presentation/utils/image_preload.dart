import 'package:flutter/material.dart';

extension ImagePreloadExtention on Image {
  void preload({
    VoidCallback? onImageLoaded,
    VoidCallback? onError,
  }) {
    image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
          onImageLoaded?.call();
        }, onError: (Object exception, StackTrace? stackTrace) {
          onError?.call();
        }));
  }
}

extension PreloadImageProviderExtension on ImageProvider {
  void preload({
    VoidCallback? onImageLoaded,
    VoidCallback? onError,
  }) {
    resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
      onImageLoaded?.call();
    }, onError: (Object exception, StackTrace? stackTrace) {
      onError?.call();
    }));
  }
}
