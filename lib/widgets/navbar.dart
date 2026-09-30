import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/utils/constants.dart';
import 'package:three_d_portfolio/personal_data/portfolio_content.dart';
class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onNavItemTap;
  final int currentSectionIndex;

  const CustomNavBar({
    super.key,
    required this.onNavItemTap,
    required this.currentSectionIndex,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // With paged navigation there's no continuous scroll offset to watch -
    // "scrolled away from the top" is simply "not on the first (Hero) page".
    final bool isScrolled = currentSectionIndex != 0;
    return AppBar(
      backgroundColor: isScrolled ? AppColors.cardBackground.withOpacity(0.9) : AppColors.background.withOpacity(0.8),
      elevation: isScrolled ? 4 : 0,
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
          onTap: () => onNavItemTap(0), // Scroll to home
          child: Text(
            SiteBranding.formalName,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(AppData.navItems.length, (index) {
            final isSelected = currentSectionIndex == index;
            return TextButton(
              onPressed: () => onNavItemTap(index),
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
          onTap: () => onNavItemTap(0), // Scroll to home
          child: Text(
            SiteBranding.informalName,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onSelected: onNavItemTap,
          itemBuilder: (context) => List.generate(AppData.navItems.length, (index) {
            return PopupMenuItem<int>(
              value: index,
              child: Text(
                AppData.navItems[index],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: currentSectionIndex == index ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}