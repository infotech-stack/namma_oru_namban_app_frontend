import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

/*
class ImagePickerHelper {
  static final _picker = ImagePicker();

  // ── Single image pick ──────────────────────────────────────
  static Future<void> pickSingle({required RxString target}) async {
    _showPickerSheet(
      onCamera: () => _pick(ImageSource.camera, target),
      onGallery: () => _pick(ImageSource.gallery, target),
    );
  }

  // ── Multiple image pick ────────────────────────────────────
  static Future<void> pickMultiple({required RxList<String> target}) async {
    _showPickerSheet(
      onCamera: () => _pickOneToList(ImageSource.camera, target),
      onGallery: () => _pickManyToList(target),
    );
  }

  // ── Bottom Sheet ───────────────────────────────────────────
  static void _showPickerSheet({
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Get.theme.dividerColor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'reg_pick_photo_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _PickerTile(
              icon: Icons.camera_alt_outlined,
              label: 'reg_camera'.tr,
              onTap: () {
                Get.back();
                onCamera();
              },
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.photo_library_outlined,
              label: 'reg_gallery'.tr,
              onTap: () {
                Get.back();
                onGallery();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // ── Internal methods ───────────────────────────────────────
  static Future<void> _pick(ImageSource source, RxString target) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file != null) target.value = file.path;
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  static Future<void> _pickOneToList(
    ImageSource source,
    RxList<String> target,
  ) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file != null) target.add(file.path);
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  static Future<void> _pickManyToList(RxList<String> target) async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (files.isNotEmpty) target.addAll(files.map((f) => f.path));
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  // PDF + Image pick
  static Future<void> pickSingleWithPdf({required RxString target}) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Get.theme.dividerColor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'reg_pick_photo_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _PickerTile(
              icon: Icons.camera_alt_outlined,
              label: 'reg_camera'.tr,
              onTap: () async {
                Get.back();
                await _pick(ImageSource.camera, target);
              },
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.photo_library_outlined,
              label: 'reg_gallery'.tr,
              onTap: () async {
                Get.back();
                await _pick(ImageSource.gallery, target);
              },
            ),
            const SizedBox(height: 12),
            // 👇 PDF option
            _PickerTile(
              icon: Icons.picture_as_pdf_rounded,
              label: 'reg_pdf'.tr, // 'Upload PDF'
              onTap: () async {
                Get.back();
                await _pickPdf(target);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static Future<void> _pickPdf(RxString target) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        target.value = result.files.single.path!;
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }
}

// ── Picker Tile Widget ─────────────────────────────────────────
class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/// ─────────────────────────────────────────────
/// ImagePickerHelper (with persistent storage)
/// ─────────────────────────────────────────────
class ImagePickerHelper {
  static final _picker = ImagePicker();

  /// Single image pick
  static Future<void> pickSingle({required RxString target}) async {
    _showPickerSheet(
      onCamera: () => _pick(ImageSource.camera, target),
      onGallery: () => _pick(ImageSource.gallery, target),
    );
  }

  /// Multiple images pick
  static Future<void> pickMultiple({
    required RxList<String> target,
    int? maxCount,
  }) async {
    _showPickerSheet(
      onCamera: () => _pickOneToList(ImageSource.camera, target, maxCount),
      onGallery: () => _pickManyToList(target, maxCount),
    );
  }

  /// Bottom sheet UI
  static void _showPickerSheet({
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Get.theme.dividerColor.withAlpha(90),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'reg_pick_photo_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _PickerTile(
              icon: Icons.camera_alt_outlined,
              label: 'reg_camera'.tr,
              onTap: () {
                Get.back();
                onCamera();
              },
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.photo_library_outlined,
              label: 'reg_gallery'.tr,
              onTap: () {
                Get.back();
                onGallery();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  /// ─────────────────────────────────────────────
  /// Internal methods
  /// ─────────────────────────────────────────────
  static Future<void> _pick(ImageSource source, RxString target) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file != null) {
        final savedPath = await _saveFileToAppDir(file.path);
        target.value = savedPath;
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  static Future<void> _pickOneToList(
    ImageSource source,
    RxList<String> target,
    int? maxCount,
  ) async {
    try {
      if (maxCount != null && target.length >= maxCount) {
        AppSnackbar.error("Maximum $maxCount images only");
        return;
      }
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file != null) {
        final savedPath = await _saveFileToAppDir(file.path);
        target.add(savedPath);
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  /* static Future<void> _pickManyToList(
    RxList<String> target,
    int? maxCount,
  ) async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (files.isNotEmpty) {
        for (var f in files) {
          final savedPath = await _saveFileToAppDir(f.path);
          target.add(savedPath);
        }
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }*/
  static Future<void> _pickManyToList(
    RxList<String> target,
    int? maxCount,
  ) async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);

      if (files.isNotEmpty) {
        int remaining = maxCount != null
            ? maxCount - target.length
            : files.length;

        if (maxCount != null && remaining <= 0) {
          AppSnackbar.error("Maximum $maxCount images only");
          return;
        }

        final selectedFiles = maxCount != null ? files.take(remaining) : files;

        for (var f in selectedFiles) {
          final savedPath = await _saveFileToAppDir(f.path);
          target.add(savedPath);
        }

        if (maxCount != null && files.length > remaining) {
          AppSnackbar.error("Only $maxCount images allowed");
        }
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  /// Single pick with PDF option
  static Future<void> pickSingleWithPdf({required RxString target}) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Get.theme.dividerColor.withAlpha(90),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'reg_pick_photo_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _PickerTile(
              icon: Icons.camera_alt_outlined,
              label: 'reg_camera'.tr,
              onTap: () async {
                Get.back();
                await _pick(ImageSource.camera, target);
              },
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.photo_library_outlined,
              label: 'reg_gallery'.tr,
              onTap: () async {
                Get.back();
                await _pick(ImageSource.gallery, target);
              },
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.picture_as_pdf_rounded,
              label: 'reg_pdf'.tr,
              onTap: () async {
                Get.back();
                await _pickPdf(target);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static Future<void> _pickPdf(RxString target) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final savedPath = await _saveFileToAppDir(result.files.single.path!);
        target.value = savedPath;
      }
    } catch (_) {
      AppSnackbar.error('reg_pick_error'.tr);
    }
  }

  /// ─────────────────────────────────────────────
  /// Save temp file to persistent App Documents Directory
  /// ─────────────────────────────────────────────
  static Future<String> _saveFileToAppDir(String tempPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = tempPath.split('/').last;
    final newFile = await File(tempPath).copy('${dir.path}/$fileName');
    return newFile.path;
  }
}

/// ─────────────────────────────────────────────
/// Picker Tile Widget
/// ─────────────────────────────────────────────
class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.primary.withAlpha(38)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
