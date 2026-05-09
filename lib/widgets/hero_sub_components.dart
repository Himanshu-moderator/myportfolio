// lib/widgets/hero_sub_components.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';
import 'dart:math'; // For clamping functions

// --- Reusable Hero Section Components ---

// Ready to Innovate Badge with Hover Effect
class ReadyToInnovateBadge extends StatefulWidget {
  const ReadyToInnovateBadge({super.key});

  @override
  State<ReadyToInnovateBadge> createState() => _ReadyToInnovateBadgeState();
}

class _ReadyToInnovateBadgeState extends State<ReadyToInnovateBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          // Clamping values to ensure they stay between 0.0 and 1.0
          final double currentGlowValue = _glowAnimation.value;
          final double opacityBoost = currentGlowValue * 0.4; // Subtle boost
          final double blurBoost = currentGlowValue * 5;
          final double spreadBoost = currentGlowValue * 2;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity((0.2 + opacityBoost).clamp(0.0, 1.0)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity((0.5 + opacityBoost).clamp(0.0, 1.0))),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity((0.3 + opacityBoost).clamp(0.0, 1.0)),
                  blurRadius: 10 + blurBoost,
                  spreadRadius: 3 + spreadBoost,
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity((0.1 + opacityBoost * 0.5).clamp(0.0, 1.0)), // More subtle secondary glow
                  blurRadius: 5 + blurBoost * 0.5,
                  spreadRadius: 1 + spreadBoost * 0.5,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.lightbulb,
                  size: 16,
                  color: CupertinoColors.systemYellow, // Icon brightens subtly
                ),
                const SizedBox(width: 8),
                Text(
                  'Ready to Innovate',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.textPrimary.withOpacity((1.0 + opacityBoost * 0.1).clamp(0.0, 1.0)), // Text brightens subtly
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Main Title: Frontend Developer
class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frontend',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 60,
            shadows: [
              Shadow(color: AppColors.textPrimary.withOpacity(0.7), blurRadius: 20),
              Shadow(color: AppColors.textPrimary.withOpacity(0.4), blurRadius: 40),
            ],
          ),
        ),
        Text(
          'Developer',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 60,
            shadows: [
              Shadow(color: AppColors.primary.withOpacity(0.8), blurRadius: 25),
              Shadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 50),
            ],
          ),
        ),
      ],
    );
  }
}

// Animated Role Text
class AnimatedRoleText extends StatelessWidget {
  const AnimatedRoleText({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        shadows: [
          Shadow(color: AppColors.textSecondary.withOpacity(0.6), blurRadius: 10),
        ],
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText('Tech Enthu |', speed: const Duration(milliseconds: 80)),
          TypewriterAnimatedText('Problem Solver |', speed: const Duration(milliseconds: 80)),
          TypewriterAnimatedText('Network & Telecom |', speed: const Duration(milliseconds: 80)),
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
      ),
    );
  }
}

// Description Paragraph
class DescriptionParagraph extends StatelessWidget {
  const DescriptionParagraph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Text(
        'Menciptakan Website Yang Inovatif, Fungsional, dan User-Friendly untuk Solusi Digital.',
        style: AppTextStyles.bodyText(context).copyWith(fontSize: 18, height: 1.6),
      ),
    );
  }
}

// Skill Chip
class SkillChip extends StatelessWidget {
  final String text;
  const SkillChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

// Unified Action Button with Neon Hover
class ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color baseColor; // For button background/border color

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.baseColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: widget.baseColor.withOpacity(_glowOpacityAnimation.value * 0.4),
                    blurRadius: 15 * _glowOpacityAnimation.value,
                    spreadRadius: 4 * _glowOpacityAnimation.value,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: widget.onTap,
                icon: FaIcon(widget.icon, size: 20),
                label: Text(widget.label),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  backgroundColor: widget.baseColor,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: widget.baseColor.withOpacity(0.5), width: 1),
                  textStyle: AppTextStyles.buttonText(context).copyWith(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Social Media Buttons with Neon Hover
class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  // Helper for individual social icon button with neon effect
  Widget _buildSocialIconButton(BuildContext context, IconData icon, String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.2), // Subtle neon glow
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: FaIcon(icon, size: 30),
        color: AppColors.textSecondary,
        onPressed: () async {
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri)) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $url')));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialIconButton(
          context,
          FontAwesomeIcons.linkedin,
          'https://linkedin.com/in/yourprofile', // Replace with your LinkedIn
        ),
        const SizedBox(width: 20),
        _buildSocialIconButton(
          context,
          FontAwesomeIcons.instagram,
          'https://instagram.com/yourprofile', // Replace with your Instagram
        ),
      ],
    );
  }
}
