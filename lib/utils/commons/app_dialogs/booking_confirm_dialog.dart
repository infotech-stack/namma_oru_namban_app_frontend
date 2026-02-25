import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlassConfirmDialog {
  static void show({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
