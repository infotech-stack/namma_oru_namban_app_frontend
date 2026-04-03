// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:userapp/core/theme/app_colors.dart';
// import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
// import 'package:userapp/utils/commons/text/b_text.dart';
//
// // Import your openDocViewer function
// // import 'package:your_app/utils/doc_viewer.dart';
//
// /// ─────────────────────────────────────────────────────────────
// /// BPhotoPickerGrid - Reusable photo picker for all vehicle types
// /// ─────────────────────────────────────────────────────────────
// class BPhotoPickerGrid extends StatelessWidget {
//   final List<String> photos; // ✅ Required: List of photo paths/URLs
//   final VoidCallback onAdd; // ✅ Required: Add photo callback
//   final Function(String path) onRemove; // ✅ Required: Remove photo callback
//   final int maxPhotos; // Optional: Max photos (default: 10, use 5 for cars)
//   final String? title; // Optional: Title text (localized key)
//   final bool isLocalized; // Optional: Whether title is localized
//   final double size; // Optional: Thumbnail size (default: 64)
//   final String viewerTitle; // Optional: Title for doc viewer
//
//   const BPhotoPickerGrid({
//     super.key,
//     required this.photos,
//     required this.onAdd,
//     required this.onRemove,
//     this.maxPhotos = 5,
//     this.title,
//     this.isLocalized = true,
//     this.size = 64,
//     this.viewerTitle = 'Photos',
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title (optional)
//         if (title != null) ...[
//           BText(
//             text: title!,
//             fontSize: 10.sp,
//             color: AppTheme.greyMedium,
//             isLocalized: isLocalized,
//           ),
//           Gap(8.h),
//         ],
//
//         // Photo Grid
//         Wrap(
//           spacing: 8.w,
//           runSpacing: 8.h,
//           children: [
//             // Existing Photos with tap-to-view
//             ...photos.asMap().entries.map(
//               (entry) => _PhotoThumb(
//                 path: entry.value,
//                 size: size,
//                 theme: theme,
//                 allPhotos: photos,
//                 currentIndex: entry.key,
//                 viewerTitle: viewerTitle,
//                 onRemove: () => onRemove(entry.value),
//               ),
//             ),
//
//             // Add Button
//             if (photos.length < maxPhotos)
//               _AddPhotoButton(
//                 theme: theme,
//                 size: size,
//                 currentCount: photos.length,
//                 maxPhotos: maxPhotos,
//                 onTap: onAdd,
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// /// ─────────────────────────────────────────────────────────────
// /// Add Photo Button
// /// ─────────────────────────────────────────────────────────────
// class _AddPhotoButton extends StatelessWidget {
//   final ThemeData theme;
//   final double size;
//   final int currentCount;
//   final int maxPhotos;
//   final VoidCallback onTap;
//
//   const _AddPhotoButton({
//     required this.theme,
//     required this.size,
//     required this.currentCount,
//     required this.maxPhotos,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: size.w,
//         height: size.w,
//         decoration: BoxDecoration(
//           color: theme.colorScheme.primary.withAlpha(15),
//           borderRadius: BorderRadius.circular(8.r),
//           border: Border.all(
//             color: theme.colorScheme.primary.withAlpha(65),
//             width: 1.2,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.add_photo_alternate_outlined,
//               color: theme.colorScheme.primary,
//               size: 22.sp,
//             ),
//             Gap(3.h),
//             Text(
//               '$currentCount/$maxPhotos',
//               style: TextStyle(
//                 fontSize: 9.sp,
//                 color: theme.colorScheme.primary,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// ─────────────────────────────────────────────────────────────
// /// Photo Thumbnail with Tap-to-View
// /// ─────────────────────────────────────────────────────────────
// class _PhotoThumb extends StatelessWidget {
//   final String path;
//   final ThemeData theme;
//   final VoidCallback onRemove;
//   final double size;
//   final List<String> allPhotos;
//   final int currentIndex;
//   final String viewerTitle;
//
//   const _PhotoThumb({
//     required this.path,
//     required this.theme,
//     required this.onRemove,
//     required this.size,
//     required this.allPhotos,
//     required this.currentIndex,
//     required this.viewerTitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final decodedPath = Uri.decodeFull(path);
//
//     return Stack(
//       children: [
//         // Tap to view fullscreen
//         GestureDetector(
//           onTap: () => openDocViewer(context, allPhotos, viewerTitle),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: decodedPath.startsWith('http')
//                 ? BCachedImage.rounded(
//                     imageUrl: decodedPath,
//                     width: size,
//                     height: size,
//                   )
//                 : File(decodedPath).existsSync()
//                 ? Image.file(
//                     File(decodedPath),
//                     width: size.w,
//                     height: size.w,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(
//                     width: size.w,
//                     height: size.w,
//                     color: AppTheme.greyLight,
//                     child: Icon(
//                       Icons.image_rounded,
//                       color: AppTheme.greyMedium,
//                       size: 24.sp,
//                     ),
//                   ),
//           ),
//         ),
//         // Remove button
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: onRemove,
//             child: Container(
//               width: 18.r,
//               height: 18.r,
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.close_rounded,
//                 color: Colors.white,
//                 size: 11.sp,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
