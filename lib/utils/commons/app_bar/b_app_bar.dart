/*
import 'package:driverapp/core/localization/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  final bool isLocalized;
  final bool centerTitle;

  final Color? backgroundColor;
  final double? elevation;

  /// 🔹 Leading options
  final bool showBackButton; // default back button
  final Widget? leadingWidget; // custom leading widget
  final VoidCallback? onBackTap; // custom back action

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  final bool showDivider;
  final Color? dividerColor;

  final bool showLanguageToggle;

  final SystemUiOverlayStyle? systemOverlayStyle;
  final TextStyle? titleStyle;

  const BAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.isLocalized = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation,
    this.showBackButton = false,
    this.leadingWidget,
    this.onBackTap,
    this.actions,
    this.bottom,
    this.showDivider = false,
    this.dividerColor,
    this.systemOverlayStyle,
    this.titleStyle,
    this.showLanguageToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? resolvedLeading;

    // Priority 1 → Custom leading widget
    if (leadingWidget != null) {
      resolvedLeading = leadingWidget;
    }
    // Priority 2 → Default back button
    else if (showBackButton) {
      resolvedLeading = IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
        onPressed: onBackTap ?? () => Get.back(),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false, // 🚫 avoid auto back
      backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading: resolvedLeading,
      actions: [
        if (showLanguageToggle) const _LanguageToggleButton(),

        if (actions != null) ...actions!,
      ],
      systemOverlayStyle:
          systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Get.isDarkMode
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: Get.isDarkMode
                ? Brightness.dark
                : Brightness.light,
          ),
      title:
          titleWidget ??
          (title != null
              ? Text(
                  isLocalized ? title!.tr : title!,
                  style:
                      titleStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                )
              : null),
      bottom: showDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                color: dividerColor ?? Colors.grey.shade300,
              ),
            )
          : bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

///LANGUAGE TOGGLE BUTTON WIDGET
class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langController = Get.find<LanguageController>();

    return Obx(
      () => IconButton(
        splashRadius: 20,
        padding: EdgeInsets.zero,
        icon: Icon(
          langController.currentLocale.value.languageCode == 'en'
              ? Icons.language
              : Icons.translate,
          color: theme.colorScheme.primary,
          size: 22,
        ),
        onPressed: () => langController.toggleLanguage(),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';

class BAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  final bool isLocalized;
  final bool centerTitle;

  final bool showBackButton;
  final Widget? leadingWidget;
  final VoidCallback? onBackTap;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  final bool showLanguageToggle;

  const BAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.isLocalized = true,
    this.centerTitle = true,
    this.showBackButton = false,
    this.leadingWidget,
    this.onBackTap,
    this.actions,
    this.bottom,
    this.showLanguageToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? resolvedLeading;

    // Custom leading
    if (leadingWidget != null) {
      resolvedLeading = leadingWidget;
    }
    // Default back button
    else if (showBackButton) {
      resolvedLeading = IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackTap ?? () => Get.back(),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.25),
      centerTitle: centerTitle,
      leading: resolvedLeading,

      // 🔥 Gradient Background
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA12CBC), // Primary Violet
              Color(0xFF8326AA), // Dark Violet
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,

      // 🔥 Actions
      actions: [
        if (actions != null) ...actions!,

        if (showLanguageToggle) const _LanguageToggleButton(),
      ],

      // 🔥 Status bar icons white
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),

      // 🔥 Title
      title:
          titleWidget ??
          (title != null
              ? Text(
                  isLocalized ? title!.tr : title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              : null),

      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// 🌍 Language Toggle Button
class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton();

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();

    return Obx(
      () => IconButton(
        splashRadius: 20,
        icon: Icon(
          langController.currentLocale.value.languageCode == 'en'
              ? Icons.language
              : Icons.translate,
          color: Colors.white,
          size: 22,
        ),
        onPressed: () => langController.toggleLanguage(),
      ),
    );
  }
}
