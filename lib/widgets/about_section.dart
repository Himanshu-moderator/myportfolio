// lib/widgets/about_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/widgets/section_title.dart' hide AppColors, AppTextStyles, AppPaddings;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For the user icon

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
            'Hello! I\'m Himanshu, a passionate Fullstack Developer with a knack for crafting robust and scalable web & Android/iOS applications. My journey in the world of technology began with a curiosity for how things work, and it quickly evolved into a drive to build and innovate.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'I specialize in both front-end and back-end development, comfortable with various frameworks and technologies. On the front end, I enjoy creating intuitive and visually appealing user interfaces with modern JavaScript frameworks like React, Vue, and Angular. On the back end, I\'m proficient in building powerful APIs and managing databases using Node.js, Python (Django/Flask), and various SQL/NoSQL databases.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'My goal is to deliver high-quality, performant, and maintainable code that solves real-world problems. I\'m a continuous learner, always exploring new technologies and best practices to enhance my skills and stay ahead in the ever-evolving tech landscape.',
            style: AppTextStyles.bodyText(context),
          ),
          const SizedBox(height: 10),
          Text(
            'When I\'m not coding, you can find me exploring new hiking trails, experimenting with photography, or diving into a good book. I\'m always open to new challenges and collaborations. Let\'s build something amazing together!',
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
      child: Icon(
        FontAwesomeIcons.userCircle, // Placeholder user icon
        size: 150,
        color: AppColors.textSecondary.withOpacity(0.6),
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
