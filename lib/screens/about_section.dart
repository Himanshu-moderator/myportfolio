// lib/screens/about_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/widgets/section_title.dart'
    hide AppColors, AppTextStyles, AppPaddings;

import 'package:three_d_portfolio/utils/constants.dart';
import 'package:three_d_portfolio/personal_data/portfolio_content.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // sectionPadding is vertical-only; this section's content Row uses
      // Expanded, which stretches edge-to-edge across the full width, so it
      // needs its own horizontal padding to avoid sitting flush against the
      // screen edge (Skills/Portfolio don't need this - their content sizes
      // to a max-width and is centered by their parent Column instead).
      padding:
          AppPaddings.sectionPadding +
          const EdgeInsets.symmetric(horizontal: 24.0),
      // REMOVED: color: AppColors.background,
      // We want the global animated background to show through, so no solid color here.
      child: ResponsiveLayout(
        mobileBody: _buildMobileLayout(context),
        tabletBody: _buildTabletAndDesktopLayout(context, isTablet: true),
        desktopBody: _buildTabletAndDesktopLayout(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding:
          AppPaddings.cardPadding, // Padding within the translucent container
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(
          0.8,
        ), // Translucent background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AboutContent.cardHeading,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.primary, // Highlighted text
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < AboutContent.paragraphs.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Text(
              AboutContent.paragraphs[i],
              style: AppTextStyles.bodyText(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      width: 250, // Fixed width for the image container
      height: 250, // Fixed height for the image container
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardBackground.withOpacity(
          0.6,
        ), // Translucent circle background
        border: Border.all(
          color: AppColors.primary.withOpacity(0.7),
          width: 3,
        ), // Glowing border
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 8,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          AboutContent.profileImageAsset,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SectionTitle(title: AboutContent.sectionTitle),
        const SizedBox(height: 40),
        _buildProfileImage(context),
        const SizedBox(height: 40),
        _buildContent(context),
        // Breathing room at the end of the section, so the last paragraph
        // isn't flush against the screen edge where the scroll transition to
        // the next section triggers.
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildTabletAndDesktopLayout(
    BuildContext context, {
    bool isTablet = false,
  }) {
    return Column(
      // Keep Column as parent to contain SectionTitle
      children: [
        const SectionTitle(title: AboutContent.sectionTitle),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3, // Content takes more space
              child: _buildContent(context),
            ),
            SizedBox(
              width: isTablet ? 30 : 60,
            ), // Spacing between content and image
            Expanded(
              flex: 2, // Image takes less space
              child: Align(
                alignment: Alignment.topCenter, // Align image to top-center
                child: _buildProfileImage(context),
              ),
            ),
          ],
        ),
        // Breathing room at the end of the section, so the content isn't
        // flush against the screen edge where the scroll transition to the
        // next section triggers.
        const SizedBox(height: 100),
      ],
    );
  }
}
