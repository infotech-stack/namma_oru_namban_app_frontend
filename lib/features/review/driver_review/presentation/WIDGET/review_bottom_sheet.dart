// // lib/features/review/presentation/widget/review_bottom_sheet.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:userapp/features/review/driver_review/presentation/review_controller.dart';
// import 'package:userapp/utils/commons/text/b_text.dart';
//
// class ReviewBottomSheet {
//   ReviewBottomSheet._();
//
//   static Future<void> show({
//     required BuildContext context,
//     required int bookingId,
//     required String driverName,
//     required String vehicleName,
//     required String totalAmount,
//   }) async {
//     // Ensure keyboard is dismissed before showing bottom sheet
//     FocusManager.instance.primaryFocus?.unfocus();
//
//     // Small delay for keyboard to dismiss
//     await Future.delayed(const Duration(milliseconds: 150));
//
//     final controller = Get.put(ReviewController(), tag: 'review_$bookingId');
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: true,
//       enableDrag: true,
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.85,
//       ),
//       barrierColor: Colors.black54,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//       ),
//       builder: (context) => _ReviewSheet(
//         controller: controller,
//         bookingId: bookingId,
//         driverName: driverName,
//         vehicleName: vehicleName,
//         totalAmount: totalAmount,
//       ),
//     );
//
//     // Clean up after bottom sheet is closed
//     if (Get.isRegistered<ReviewController>(tag: 'review_$bookingId')) {
//       // Ensure text field is unfocused before disposal
//       FocusManager.instance.primaryFocus?.unfocus();
//       await Future.delayed(const Duration(milliseconds: 100));
//       Get.delete<ReviewController>(tag: 'review_$bookingId');
//     }
//   }
// }
//
// class _ReviewSheet extends StatefulWidget {
//   final ReviewController controller;
//   final int bookingId;
//   final String driverName;
//   final String vehicleName;
//   final String totalAmount;
//
//   const _ReviewSheet({
//     required this.controller,
//     required this.bookingId,
//     required this.driverName,
//     required this.vehicleName,
//     required this.totalAmount,
//   });
//
//   @override
//   State<_ReviewSheet> createState() => _ReviewSheetState();
// }
//
// class _ReviewSheetState extends State<_ReviewSheet> {
//   final FocusNode _commentFocusNode = FocusNode();
//
//   @override
//   void dispose() {
//     // Dispose focus node
//     _commentFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return GestureDetector(
//       onTap: () {
//         // Dismiss keyboard when tapping outside
//         _commentFocusNode.unfocus();
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: theme.colorScheme.secondary,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//         ),
//         child: Obx(
//           () => widget.controller.isSubmitted.value
//               ? _buildSuccessView(theme)
//               : _buildRatingView(theme, context),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSuccessView(ThemeData theme) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 72.w,
//             height: 72.h,
//             decoration: BoxDecoration(
//               color: const Color(0xFFD1FAE5),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.check_rounded,
//               color: const Color(0xFF059669),
//               size: 36.sp,
//             ),
//           ),
//           Gap(16.h),
//           BText(
//             text: 'review_submitted',
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w700,
//             color: theme.colorScheme.onSurface,
//             isLocalized: true,
//           ),
//           Gap(6.h),
//           BText(
//             text: 'review_submitted_msg',
//             fontSize: 13.sp,
//             color: theme.dividerColor,
//             isLocalized: true,
//           ),
//           Gap(24.h),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: theme.colorScheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               child: Text(
//                 'close'.tr,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: theme.colorScheme.secondary,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRatingView(ThemeData theme, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Drag handle
//             Center(
//               child: Container(
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: theme.dividerColor.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//               ),
//             ),
//             Gap(20.h),
//
//             // Trip complete banner
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(14.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD1FAE5),
//                 borderRadius: BorderRadius.circular(14.r),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 42.w,
//                     height: 42.h,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF059669).withValues(alpha: 0.15),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.local_shipping_rounded,
//                       color: const Color(0xFF059669),
//                       size: 22.sp,
//                     ),
//                   ),
//                   Gap(12.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'trip_completed'.tr,
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w700,
//                             color: const Color(0xFF065F46),
//                           ),
//                         ),
//                         Gap(2.h),
//                         Text(
//                           widget.vehicleName,
//                           style: TextStyle(
//                             fontSize: 11.sp,
//                             color: const Color(0xFF059669),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         'total_paid'.tr,
//                         style: TextStyle(
//                           fontSize: 10.sp,
//                           color: const Color(0xFF059669),
//                         ),
//                       ),
//                       Text(
//                         widget.totalAmount,
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF065F46),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Gap(22.h),
//
//             // Title
//             BText(
//               text: 'rate_your_trip',
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w700,
//               color: theme.colorScheme.onSurface,
//               isLocalized: true,
//             ),
//             Gap(4.h),
//
//             // Driver name
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 28.w,
//                   height: 28.h,
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.primary.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.person_rounded,
//                     size: 16.sp,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//                 Gap(6.w),
//                 Text(
//                   widget.driverName,
//                   style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
//                 ),
//               ],
//             ),
//
//             Gap(20.h),
//
//             // Stars
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (i) {
//                 final starIndex = i + 1;
//                 return Obx(
//                   () => GestureDetector(
//                     onTap: () {
//                       _commentFocusNode.unfocus();
//                       widget.controller.setRating(starIndex);
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 6.w),
//                       child: AnimatedScale(
//                         scale:
//                             widget.controller.selectedRating.value >= starIndex
//                             ? 1.15
//                             : 1.0,
//                         duration: const Duration(milliseconds: 150),
//                         child: Icon(
//                           widget.controller.selectedRating.value >= starIndex
//                               ? Icons.star_rounded
//                               : Icons.star_outline_rounded,
//                           size: 42.sp,
//                           color:
//                               widget.controller.selectedRating.value >=
//                                   starIndex
//                               ? const Color(0xFFF59E0B)
//                               : theme.dividerColor.withValues(alpha: 0.35),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//
//             Gap(6.h),
//
//             // Rating label
//             Obx(
//               () => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: widget.controller.selectedRating.value > 0
//                     ? Text(
//                         widget.controller.ratingLabel,
//                         key: ValueKey(widget.controller.selectedRating.value),
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.w600,
//                           color: _ratingLabelColor(
//                             widget.controller.selectedRating.value,
//                           ),
//                         ),
//                       )
//                     : SizedBox(height: 18.h),
//               ),
//             ),
//
//             Gap(16.h),
//
//             // Comment field
//             TextField(
//               focusNode: _commentFocusNode,
//               controller: widget.controller.commentController,
//               onChanged: (v) => widget.controller.commentText.value = v,
//               maxLines: 3,
//               maxLength: 200,
//               decoration: InputDecoration(
//                 hintText: 'review_hint'.tr,
//                 hintStyle: TextStyle(
//                   fontSize: 13.sp,
//                   color: theme.dividerColor.withValues(alpha: 0.5),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 14.w,
//                   vertical: 12.h,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                   borderSide: BorderSide(
//                     color: theme.dividerColor.withValues(alpha: 0.2),
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                   borderSide: BorderSide(
//                     color: theme.dividerColor.withValues(alpha: 0.2),
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                   borderSide: BorderSide(
//                     color: theme.colorScheme.primary,
//                     width: 1.5,
//                   ),
//                 ),
//                 counterStyle: TextStyle(
//                   fontSize: 10.sp,
//                   color: theme.dividerColor,
//                 ),
//               ),
//             ),
//
//             Gap(16.h),
//
//             // Submit + Skip buttons
//             Obx(
//               () => Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed:
//                           widget.controller.canSubmit &&
//                               !widget.controller.isSubmitting.value
//                           ? () async {
//                               _commentFocusNode.unfocus();
//                               await Future.delayed(
//                                 const Duration(milliseconds: 100),
//                               );
//                               widget.controller.submitReview(
//                                 bookingId: widget.bookingId, vehicleId: widget.,
//                               );
//                             }
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: theme.colorScheme.primary,
//                         disabledBackgroundColor: theme.colorScheme.primary
//                             .withValues(alpha: 0.35),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 14.h),
//                       ),
//                       child: widget.controller.isSubmitting.value
//                           ? SizedBox(
//                               width: 20.w,
//                               height: 20.h,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: theme.colorScheme.secondary,
//                               ),
//                             )
//                           : Text(
//                               'submit_review'.tr,
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: theme.colorScheme.secondary,
//                               ),
//                             ),
//                     ),
//                   ),
//                   Gap(8.h),
//                   GestureDetector(
//                     onTap: () => _handleSkip(),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 6.h),
//                       child: Text(
//                         'skip'.tr,
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           color: theme.dividerColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleSkip() async {
//     // Unfocus keyboard first
//     _commentFocusNode.unfocus();
//
//     // Small delay to ensure keyboard is dismissed
//     await Future.delayed(const Duration(milliseconds: 150));
//
//     // Check if mounted before proceeding
//     if (!mounted) return;
//
//     // Call skip from controller
//     await widget.controller.skip();
//
//     // Close the bottom sheet if still mounted
//     if (mounted) {
//       Navigator.of(context).pop();
//     }
//   }
//
//   Color _ratingLabelColor(int rating) {
//     switch (rating) {
//       case 1:
//       case 2:
//         return const Color(0xFFEF4444);
//       case 3:
//         return const Color(0xFFF59E0B);
//       case 4:
//       case 5:
//         return const Color(0xFF059669);
//       default:
//         return const Color(0xFF6B7280);
//     }
//   }
// }
