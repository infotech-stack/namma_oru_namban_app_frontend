// lib/utils/commons/widgets/b_cached_image.dart

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:userapp/utils/commons/helper/image_picker_helper/pdf_viewer_screen.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_container.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_widget.dart';

enum BCachedImageShape { circle, roundedRect, square }

class BCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? size;
  final double borderRadius;
  final BCachedImageShape shape;
  final BoxFit fit;
  final Widget? errorWidget;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Border? border;

  const BCachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.size,
    this.borderRadius = 8,
    this.shape = BCachedImageShape.roundedRect,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.backgroundColor,
    this.onTap,
    this.border,
  });

  // ── FACTORY ─────────────────────────────

  factory BCachedImage.circle({
    Key? key,
    String? imageUrl,
    double size = 56,
    VoidCallback? onTap,
    Border? border,
  }) => BCachedImage(
    key: key,
    imageUrl: imageUrl,
    size: size,
    shape: BCachedImageShape.circle,
    onTap: onTap,
    border: border,
  );

  factory BCachedImage.rounded({
    Key? key,
    String? imageUrl,
    double? width,
    double? height,
    double radius = 12,
  }) => BCachedImage(
    key: key,
    imageUrl: imageUrl,
    width: width,
    height: height,
    borderRadius: radius,
  );
  factory BCachedImage.document({
    Key? key,
    String? imageUrl,
    double? width,
    double? height,
    VoidCallback? onTap,
    double? borderRadius,
  }) => BCachedImage(
    key: key,
    imageUrl: imageUrl,
    width: width,
    height: height ?? 120,
    borderRadius: borderRadius ?? 10,
    shape: BCachedImageShape.roundedRect,
    fit: BoxFit.cover,
    backgroundColor: const Color(0xFFF5F5F5),
    onTap: onTap,
  );
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final w = size ?? width;
    final h = size ?? height;

    Widget imageWidget = _resolveImage(context, theme, w, h);

    Widget shaped;

    switch (shape) {
      case BCachedImageShape.circle:
        shaped = ClipOval(
          child: SizedBox(width: w, height: h, child: imageWidget),
        );
        break;

      case BCachedImageShape.roundedRect:
        shaped = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: imageWidget,
        );
        break;

      case BCachedImageShape.square:
        shaped = ClipRect(child: imageWidget);
        break;
    }

    if (border != null) {
      shaped = Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          shape: shape == BCachedImageShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: shape != BCachedImageShape.circle
              ? BorderRadius.circular(borderRadius.r)
              : null,
          border: border,
        ),
        child: shaped,
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: shaped);
    }

    return shaped;
  }

  // ── MAIN LOGIC ─────────────────────────

  Widget _resolveImage(
    BuildContext context,
    ThemeData theme,
    double? w,
    double? h,
  ) {
    final url = imageUrl;

    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    if (url == null || url.isEmpty) {
      return _placeholder(theme, bgColor, w, h);
    }

    // 📄 PDF
    if (_isPdf(url)) {
      return _pdfWidget(context, url, w, h, bgColor, theme);
    }

    // 🌐 NETWORK IMAGE
    if (_isNetwork(url)) {
      return CachedNetworkImage(
        imageUrl: url,
        width: w,
        height: h,
        fit: fit,
        placeholder: (_, __) => _shimmer(w, h),
        errorWidget: (_, __, ___) => _error(theme, bgColor, w, h),
      );
    }

    // 📁 LOCAL FILE IMAGE
    if (_isLocal(url)) {
      return Image.file(
        File(url),
        width: w,
        height: h,
        fit: fit,
        errorBuilder: (_, __, ___) => _error(theme, bgColor, w, h),
      );
    }

    // 📦 ASSET
    if (_isAsset(url)) {
      return Image.asset(url, width: w, height: h, fit: fit);
    }

    // 🔐 BASE64
    if (_isBase64(url)) {
      try {
        final bytes = base64Decode(url.split(',').last);
        return Image.memory(bytes, width: w, height: h, fit: fit);
      } catch (_) {
        return _error(theme, bgColor, w, h);
      }
    }

    return _error(theme, bgColor, w, h);
  }

  // ── PDF UI ─────────────────────────

  Widget _pdfWidget(
    BuildContext context,
    String url,
    double? w,
    double? h,
    Color bg,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PdfViewerScreen(path: url)),
            );
          },
      child: Container(
        width: w,
        height: h,
        color: bg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
            const SizedBox(height: 6),
            Text("View PDF", style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  // ── HELPERS ─────────────────────────

  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');

  bool _isNetwork(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  bool _isLocal(String url) => url.startsWith('/') || url.startsWith('file://');

  bool _isAsset(String url) => url.startsWith('assets/');

  bool _isBase64(String url) => url.startsWith('data:image');

  Widget _shimmer(double? w, double? h) {
    return BShimmerWidget(
      child: BShimmerContainer(
        width: w,
        height: h,
        borderRadius: shape == BCachedImageShape.circle
            ? (w ?? 50) / 2
            : borderRadius,
      ),
    );
  }

  Widget _error(ThemeData theme, Color bg, double? w, double? h) {
    return Container(
      width: w,
      height: h,
      color: bg,
      child: Icon(Icons.broken_image, color: theme.dividerColor),
    );
  }

  Widget _placeholder(ThemeData theme, Color bg, double? w, double? h) {
    return Container(
      width: w,
      height: h,
      color: bg,
      child: Icon(Icons.image, color: theme.dividerColor),
    );
  }
}
