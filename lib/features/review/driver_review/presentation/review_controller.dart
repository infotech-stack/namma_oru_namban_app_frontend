// lib/features/review/driver_review/presentation/review_controller.dart

import 'package:flutter/material.dart';
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
  final RxBool isAlreadyReviewed = false.obs; // ← new
  final RxString errorMessage = ''.obs;

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

  bool get canSubmit => selectedRating.value > 0 && !isAlreadyReviewed.value;

  void setRating(int rating) {
    selectedRating.value = rating;
    errorMessage.value = '';
  }

  Future<void> submitReview({
    required int bookingId,
    required int vehicleId,
  }) async {
    if (_addReviewUseCase == null) {
      errorMessage.value = 'Review service not available';
      return;
    }
    if (isSubmitting.value) return;
    if (!canSubmit) {
      if (selectedRating.value == 0) {
        errorMessage.value = 'please_select_rating'.tr;
        _showErrorSnackbar('please_select_rating'.tr);
      }
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
        AppLogger.info('[Review] Submitted for booking: $bookingId');
        _showSuccessSnackbar('review_thank_you'.tr);
        // No auto-pop — user stays and sees the success state
      } else {
        final errMsg = result.error ?? 'failed_to_submit_review'.tr;
        _handleError(errMsg);
      }
    } catch (e) {
      AppLogger.error('[Review] Submit error: $e');
      _handleError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Central error handler ─────────────────────────────────────────────────
  void _handleError(String error) {
    if (_isAlreadyReviewedError(error)) {
      // Treat "already reviewed" as a submitted state — show success UI
      isAlreadyReviewed.value = true;
      isSubmitted.value = true;
      AppLogger.info('[Review] Already reviewed — showing submitted state');
    } else {
      errorMessage.value = _getUserFriendlyError(error);
      _showErrorSnackbar(errorMessage.value);
    }
  }

  bool _isAlreadyReviewedError(String error) {
    final lower = error.toLowerCase();
    return lower.contains('already reviewed') ||
        lower.contains('already submitted') ||
        lower.contains('use edit instead');
  }

  String _getUserFriendlyError(String error) {
    if (error.contains('Rating must be')) return 'rating_range_error'.tr;
    if (error.contains('Vehicle not found')) return 'vehicle_not_found'.tr;
    if (error.contains('network') || error.contains('timeout')) {
      return 'network_error'.tr;
    }
    return error;
  }

  void _showErrorSnackbar(String message) {
    AppSnackbar.error(title: 'error'.tr, message, isRaw: true);
  }

  void _showSuccessSnackbar(String message) {
    AppSnackbar.success(title: 'success'.tr, message, isRaw: true);
  }

  void clearError() {
    errorMessage.value = '';
  }

  void resetForm() {
    selectedRating.value = 0;
    commentController.clear();
    commentText.value = '';
    errorMessage.value = '';
    isSubmitted.value = false;
    isAlreadyReviewed.value = false;
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
