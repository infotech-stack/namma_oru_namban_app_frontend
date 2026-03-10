// lib/features/vehicle_details/presentation/widgets/vehicle_image_carousel.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class VehicleImageCarousel extends StatefulWidget {
  final List<String?> images;
  final double height;
  final Duration autoScrollDuration;
  final Duration animationDuration;

  const VehicleImageCarousel({
    super.key,
    required this.images,
    this.height = 220,
    this.autoScrollDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<VehicleImageCarousel> createState() => _VehicleImageCarouselState();
}

class _VehicleImageCarouselState extends State<VehicleImageCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  // ── Filter null/empty — always 1 fallback ────────────────────
  List<String?> get _safeImages {
    final filtered = widget.images
        .where((img) => img != null && img.trim().isNotEmpty)
        .toList();
    return filtered.isEmpty ? [null] : filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = theme.colorScheme.primary;
    final images = _safeImages;
    final hasMulti = images.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── CarouselSlider ────────────────────────────────────
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: images.length,
          options: CarouselOptions(
            height: widget.height.h,
            autoPlay: hasMulti, // auto scroll only if multiple
            autoPlayInterval: widget.autoScrollDuration,
            autoPlayAnimationDuration: widget.animationDuration,
            autoPlayCurve: Curves.easeInOutCubic,
            viewportFraction: 1.0, // full width
            enlargeCenterPage: false,
            enableInfiniteScroll: hasMulti, // loop only if multiple
            onPageChanged: (index, _) => setState(() => _currentIndex = index),
          ),
          itemBuilder: (_, i, __) => _buildImageCard(theme, p, images[i]),
        ),

        // ── Animated dot indicators ───────────────────────────
        if (hasMulti) ...[
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final isActive = _currentIndex == i;
              return GestureDetector(
                onTap: () => _controller.animateToPage(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: isActive ? 20.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isActive ? p : p.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  // ── Image card ───────────────────────────────────────────────
  Widget _buildImageCard(ThemeData theme, Color p, String? imgPath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [p.withValues(alpha: 0.15), p.withValues(alpha: 0.06)],
          ),
          border: Border.all(color: p.withValues(alpha: 0.18), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: p.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: imgPath != null
              ? Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(theme, p),
                )
              : _buildPlaceholder(theme, p),
        ),
      ),
    );
  }

  // ── Placeholder ──────────────────────────────────────────────
  Widget _buildPlaceholder(ThemeData theme, Color p) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.withValues(alpha: 0.10), p.withValues(alpha: 0.04)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_rounded,
            size: 52.sp,
            color: p.withValues(alpha: 0.35),
          ),
          Gap(8.h),
          Text(
            'No Image',
            style: TextStyle(
              fontSize: 12.sp,
              color: p.withValues(alpha: 0.45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
