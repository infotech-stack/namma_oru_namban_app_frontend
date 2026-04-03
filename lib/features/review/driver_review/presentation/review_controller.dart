// lib/features/review/driver_review/presentation/review_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/add_review_usecase.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class ReviewController extends GetxController {
  final AddReviewUseCase? _addReviewUseCase;

  final TextEditingController commentController = TextEditingController();
  final RxInt selectedRating = 0.obs;
  final RxString commentText = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isSubmitted = false.obs;
  final RxString errorMessage = ''.obs; // Add error message

  ReviewController({AddReviewUseCase? addReviewUseCase})
    : _addReviewUseCase = addReviewUseCase;

  String get ratingLabel {
    switch (selectedRating.value) {
      case 1:
        return 'Poor'.tr;
      case 2:
        return 'Fair'.tr;
      case 3:
        return 'Good'.tr;
      case 4:
        return 'Very Good'.tr;
      case 5:
        return 'Excellent'.tr;
      default:
        return '';
    }
  }

  bool get canSubmit => selectedRating.value > 0;

  void setRating(int rating) {
    selectedRating.value = rating;
    errorMessage.value = ''; // Clear error when rating changes
  }

  Future<void> submitReview({
    required int bookingId,
    required int vehicleId,
  }) async {
    if (_addReviewUseCase == null) {
      AppLogger.error('[Review] AddReviewUseCase not provided');
      errorMessage.value = 'Review service not available';
      _showErrorSnackbar('Review service not available');
      return;
    }

    if (isSubmitting.value) return;
    if (!canSubmit) {
      errorMessage.value = 'Please select a rating';
      _showErrorSnackbar('Please select a rating');
      return;
    }

    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final result = await _addReviewUseCase!(
        vehicleId,
        selectedRating.value,
        commentText.value.trim(),
      );

      if (result.isSuccess) {
        isSubmitted.value = true;
        AppLogger.info(
          '[Review] Review submitted successfully for booking: $bookingId',
        );

        // Show success message
        _showSuccessSnackbar('Thank you for your review!');

        // Wait and close
        await Future.delayed(const Duration(seconds: 2));

        if (Get.context != null) {
          Navigator.of(Get.context!).pop();
        }
      } else {
        // Handle API error
        final errorMsg = result.error ?? 'Failed to submit review';
        AppLogger.error('[Review] Submit failed: $errorMsg');
        errorMessage.value = errorMsg;
        _showErrorSnackbar(_getUserFriendlyError(errorMsg));
      }
    } catch (e) {
      AppLogger.error('[Review] Submit error: $e');
      errorMessage.value = e.toString();
      _showErrorSnackbar('Something went wrong. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  String _getUserFriendlyError(String error) {
    if (error.contains('already reviewed')) {
      return 'You have already reviewed this vehicle';
    } else if (error.contains('Rating must be')) {
      return 'Rating must be between 1 and 5';
    } else if (error.contains('Vehicle not found')) {
      return 'Vehicle not found';
    }
    return error;
  }

  void _showErrorSnackbar(String message) {
    AppSnackbar.error(title: "ERROR", message, isRaw: true);
  }

  void _showSuccessSnackbar(String message) {
    AppSnackbar.success(title: "Success", message, isRaw: true);
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> skip() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 100));

    if (Get.context != null) {
      Navigator.of(Get.context!).pop();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
