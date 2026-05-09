import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import '../utils/constants.dart';
import '../utils/data.dart';
class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  final AutoScrollController scrollController;
  final Function(int) onNavItemTap;
  final int currentSectionIndex;

  const CustomNavBar({
    super.key,
    required this.scrollController,
    required this.onNavItemTap,
    required this.currentSectionIndex,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    // Only update state if _isScrolled state changes
    final newIsScrolled = widget.scrollController.offset > 0;
    if (newIsScrolled != _isScrolled) {
      setState(() {
        _isScrolled = newIsScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _isScrolled ? AppColors.cardBackground.withOpacity(0.9) : AppColors.background.withOpacity(0.8),
      elevation: _isScrolled ? 4 : 0,
      centerTitle: true,
      title: ResponsiveLayout(
        mobileBody: _buildMobileNavBar(context),
        tabletBody: _buildDesktopNavBar(context), // Same as desktop for tablet for now
        desktopBody: _buildDesktopNavBar(context),
      ),
      // This will ensure the app bar respects safe areas on mobile devices.
      toolbarHeight: kToolbarHeight,
    );
  }

  Widget _buildDesktopNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => widget.onNavItemTap(0), // Scroll to home
          child: Text(
            'HC.',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(AppData.navItems.length, (index) {
            final isSelected = widget.currentSectionIndex == index;
            return TextButton(
              onPressed: () => widget.onNavItemTap(index),
              style: TextButton.styleFrom(
                foregroundColor: isSelected ? AppColors.accent : AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppData.navItems[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMobileNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => widget.onNavItemTap(0), // Scroll to home
          child: Text(
            'Himanshu.',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onSelected: widget.onNavItemTap,
          itemBuilder: (context) => List.generate(AppData.navItems.length, (index) {
            return PopupMenuItem<int>(
              value: index,
              child: Text(
                AppData.navItems[index],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: widget.currentSectionIndex == index ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}