// lib/widgets/contact_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';
import '../utils/data.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < AppBreakpoints.mobile;

    return Container(
      padding: AppPaddings.sectionPadding,
      // REMOVED: color: AppColors.background,
      child: Column(
        children: [
          const SectionTitle(title: 'Get In Touch'),
          const SizedBox(height: 40),
          Container(
            constraints: const BoxConstraints(maxWidth: 800), // Constrain width for form
            padding: AppPaddings.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withOpacity(0.8), // Translucent background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have a project in mind or just want to chat? Feel free to reach out!',
                  style: AppTextStyles.bodyText(context).copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.5),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement form submission logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message sent! (Mock submission)')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: AppPaddings.buttonPadding,
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      'Send Message',
                      style: AppTextStyles.buttonText(context).copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Or connect with me on social media:',
                    style: AppTextStyles.bodyText(context).copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AppData.socialLinks.map((link) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 15.0),
                      child: IconButton(
                        icon: FaIcon(link.icon, size: isMobile ? 30 : 40),
                        color: AppColors.primary,
                        onPressed: () async {
                          final Uri url = Uri.parse(link.url);
                          if (!await launchUrl(url)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not launch ${link.url}')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
