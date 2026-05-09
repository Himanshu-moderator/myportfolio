// lib/widgets/skill_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/widgets/section_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For skill icons

import '../utils/constants.dart';
import '../utils/data.dart';

class SkillSection extends StatelessWidget {
  const SkillSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.sectionPadding,
      // REMOVED: color: AppColors.background,
      child: Column(
        children: [
          const SectionTitle(title: 'My Skills'),
          ResponsiveLayout(
            mobileBody: _buildSkillGrid(context, 2), // 2 columns for mobile
            tabletBody: _buildSkillGrid(context, 3), // 3 columns for tablet
            desktopBody: _buildSkillGrid(context, 6), // 6 columns for desktop
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGrid(BuildContext context, int crossAxisCount) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200), // Max width for content
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.0, // Square aspect ratio for skill cards
        ),
        itemCount: AppData.skills.length,
        itemBuilder: (context, index) {
          final skill = AppData.skills[index];
          return _SkillCard(skill: skill);
        },
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -5)).animate(
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
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground.withOpacity(0.8), // Translucent background
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(_controller.value * 0.3), // Neon glow on hover
                      blurRadius: 15 * _controller.value,
                      spreadRadius: 5 * _controller.value,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.skill.icon != null)
                      FaIcon(
                        widget.skill.icon!,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    if (widget.skill.icon != null) const SizedBox(height: 10),
                    Text(
                      widget.skill.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
