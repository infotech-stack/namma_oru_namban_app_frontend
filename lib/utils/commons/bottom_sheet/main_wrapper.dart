import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/features/booking/presentation/screen/my_booking_screen.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/features/home/presentation/screens/home_screen.dart';
import 'package:userapp/features/profile/presentation/screen/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final HomeController controller = Get.find();

  final pages = [HomeScreen(), MyBookingScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    final int initialIndex = (args is int) ? args : 0;

    controller.currentNavIndex.value = initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.currentNavIndex.value],
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(theme, Icons.home_rounded, 'home', 0),
                _navItem(theme, Icons.calendar_month_outlined, 'my_booking', 1),
                _navItem(theme, Icons.person_outline_rounded, 'profile', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(ThemeData theme, IconData icon, String labelKey, int index) {
    final isSelected = controller.currentNavIndex.value == index;

    return GestureDetector(
      onTap: () => controller.onNavTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
          ),
          Text(
            labelKey.tr,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
