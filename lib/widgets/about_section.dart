// lib/widgets/about_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/widgets/section_title.dart' hide AppColors, AppTextStyles, AppPaddings;

import '../utils/constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.sectionPadding,
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
      padding: AppPaddings.cardPadding, // Padding within the translucent container
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.8), // Translucent background
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
            'A Little Bit About Me',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.primary, // Highlighted text
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m Himanshu, an aspiring Associate Product Manager with a Product Management certification from Airtribe. I\'ve been focused on turning that foundation into real-world impact, built on a genuine curiosity for how products work and why users behave the way they do.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'I\'m especially drawn to fintech and fast commerce, where speed, trust, and user experience all have to work together under pressure. I focus on translating user needs into clear product decisions - from problem definition to roadmap prioritization - using tools like Jira, Figma, and SQL to stay close to both the user and the data.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'My interest in psychology shapes how I think about products - understanding why people behave the way they do is, to me, the real foundation of good product decisions. I\'m a continuous learner, always exploring new frameworks for product thinking, and how AI can make both products and teams work smarter.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'Outside of product, I follow the forex markets, love traveling to new places, and enjoy photography along the way. I\'m always open to new challenges and conversations - let\'s turn the next big idea into a product people love.',
            style: AppTextStyles.bodyText(context),
          ),
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
        color: AppColors.cardBackground.withOpacity(0.6), // Translucent circle background
        border: Border.all(color: AppColors.primary.withOpacity(0.7), width: 3), // Glowing border
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
          'assets/profile.webp',
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
        const SectionTitle(title: 'About Me'),
        const SizedBox(height: 40),
        _buildProfileImage(context),
        const SizedBox(height: 40),
        _buildContent(context),
      ],
    );
  }

  Widget _buildTabletAndDesktopLayout(BuildContext context, {bool isTablet = false}) {
    return Column( // Keep Column as parent to contain SectionTitle
      children: [
        const SectionTitle(title: 'About Me'),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3, // Content takes more space
              child: _buildContent(context),
            ),
            SizedBox(width: isTablet ? 30 : 60), // Spacing between content and image
            Expanded(
              flex: 2, // Image takes less space
              child: Align(
                alignment: Alignment.topCenter, // Align image to top-center
                child: _buildProfileImage(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
