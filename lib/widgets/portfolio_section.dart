// lib/widgets/portfolio_section.dart
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/widgets/responsive_layout.dart';
import 'package:three_d_portfolio/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';
import '../utils/data.dart'; // Ensure this is imported for Project and Certificate models

// Enum to define the active tab
enum PortfolioTab { projects, certificates } // Removed techStack

class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> with SingleTickerProviderStateMixin {
  late PortfolioTab _selectedTab;
  late AnimationController _tabSwitchController; // Controller for tab content fade

  @override
  void initState() {
    super.initState();
    _selectedTab = PortfolioTab.projects; // Default to projects tab
    _tabSwitchController = AnimationController(
      duration: const Duration(milliseconds: 200), // Swift animation for tab content fade
      vsync: this,
    );
    _tabSwitchController.forward(); // Play animation initially for the default tab
  }

  @override
  void dispose() {
    _tabSwitchController.dispose();
    super.dispose();
  }

  void _switchTab(PortfolioTab tab) {
    if (_selectedTab != tab) {
      setState(() {
        _selectedTab = tab;
      });
      // Restart animation for content fading in/out
      _tabSwitchController.forward(from: 0.0);
    }
  }

  // Helper to build a single tab button for the segmented toggle control
  Widget _buildToggleTabButton({
    required PortfolioTab tab,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedTab == tab;
    return Expanded( // Ensures buttons take equal space in the row
      child: GestureDetector(
        onTap: () => _switchTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Swift duration for smoother visual transition
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            // Only the selected tab gets a background gradient
            gradient: isSelected
                ? LinearGradient(
              colors: [AppColors.primary, AppColors.accent], // Gradient for the selected state
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null, // No gradient for unselected
            color: isSelected ? null : Colors.transparent, // Transparent for unselected, or handled by gradient
            borderRadius: BorderRadius.circular(100), // Fully rounded corners for the slider
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 20,
                color: isSelected ? AppColors.background : AppColors.textPrimary, // Icon color changes with selection
              ),
              const SizedBox(width: 8),
              Flexible( // Use Flexible to prevent text overflow on smaller screens
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isSelected ? AppColors.background : AppColors.textPrimary, // Text color changes with selection
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.sectionPadding,
      // REMOVED: color: AppColors.background, // This line was causing the opacity issue
      child: Column(
        children: [
          const SectionTitle(title: 'Portfolio Showcase'),
          Text(
            'Explore my journey through projects, certifications, and technical expertise. Each section represents a milestone in my continuous learning path.',
            style: AppTextStyles.bodyText(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Tab Selection Buttons (Toggle Switch Style)
          Container(
            constraints: const BoxConstraints(maxWidth: 400), // Constrain the width of the tab switcher
            padding: const EdgeInsets.all(5), // Padding inside the main container, creates the "border" around the slider
            decoration: BoxDecoration(
              // Background gradient for the toggle button itself (outer container)
              gradient: LinearGradient(
                colors: [AppColors.cardBackground.withOpacity(0.9), AppColors.background], // Darker gradient for the toggle
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100), // Fully rounded corners for the outer container
              border: Border.all(color: AppColors.border.withOpacity(0.8), width: 1), // Prominent border
              boxShadow: [ // Subtle shadow for depth
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleTabButton(
                  tab: PortfolioTab.projects,
                  label: 'Projects',
                  icon: Icons.folder_open,
                ),
                _buildToggleTabButton(
                  tab: PortfolioTab.certificates,
                  label: 'Certificates',
                  icon: Icons.school,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Conditionally display content based on selected tab
          AnimatedBuilder(
            animation: _tabSwitchController,
            builder: (context, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(_tabSwitchController),
                child: _buildCurrentTabContent(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent(BuildContext context) {
    switch (_selectedTab) {
      case PortfolioTab.projects:
        return ResponsiveLayout(
          mobileBody: _buildProjectGrid(context, 1), // 1 column for mobile
          tabletBody: _buildProjectGrid(context, 2), // 2 columns for tablet
          desktopBody: _buildProjectGrid(context, 3), // 3 columns for desktop
        );
      case PortfolioTab.certificates:
        return ResponsiveLayout(
          mobileBody: _buildCertificateGrid(context, 1), // 1 column for mobile
          tabletBody: _buildCertificateGrid(context, 2), // 2 columns for tablet
          desktopBody: _buildCertificateGrid(context, 3), // 3 columns for desktop
        );
    }
  }

  Widget _buildProjectGrid(BuildContext context, int crossAxisCount) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200), // Max width for content
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.8, // Adjusted aspect ratio slightly to give more vertical space
        ),
        itemCount: AppData.projects.length,
        itemBuilder: (context, index) {
          final project = AppData.projects[index];
          return _ProjectCard(project: project);
        },
      ),
    );
  }

  // --- NEW: Certificate Grid ---
  Widget _buildCertificateGrid(BuildContext context, int crossAxisCount) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.8, // Adjust as needed for certificate images
        ),
        itemCount: AppData.certificates.length,
        itemBuilder: (context, index) {
          final certificate = AppData.certificates[index];
          return _CertificateCard(certificate: certificate);
        },
      ),
    );
  }
}

// --- _ProjectCard (Existing, just copied for context) ---
class _ProjectCard extends StatefulWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
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
            child: Card(
              color: AppColors.cardBackground.withOpacity(0.3), // Lower opacity for translucency
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      widget.project.imageUrl,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.background.withOpacity(0.5), // Fallback also translucent
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary.withOpacity(0.5)),
                        );
                      },
                    ),
                  ),
                  Expanded( // Use Expanded to give remaining space to this Column
                    child: Padding(
                      padding: AppPaddings.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Use Flexible for description text to allow it to wrap without overflowing
                          Flexible(
                            child: Text(
                              widget.project.description,
                              style: AppTextStyles.bodyText(context),
                              maxLines: 3, // Keep maxLines to constrain the text visually
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: widget.project.technologies.map((tech) => Chip(
                              label: Text(tech, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.textPrimary)),
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            )).toList(),
                          ),
                          // Add Spacer to push buttons to the bottom
                          const Spacer(),
                          AnimatedOpacity(
                            opacity: _opacityAnimation.value,
                            duration: const Duration(milliseconds: 200),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (widget.project.githubUrl != null)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _launchUrl(widget.project.githubUrl!),
                                      icon: const FaIcon(FontAwesomeIcons.github, size: 20),
                                      label: const Text('GitHub'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.textPrimary,
                                        side: const BorderSide(color: AppColors.primary),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                                if (widget.project.githubUrl != null && widget.project.liveUrl != null)
                                  const SizedBox(width: 10),
                                if (widget.project.liveUrl != null)
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _launchUrl(widget.project.liveUrl!),
                                      icon: const FaIcon(FontAwesomeIcons.solidEye, size: 20),
                                      label: const Text('Live Demo'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accent,
                                        foregroundColor: AppColors.textPrimary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- NEW: _CertificateCard Widget ---
class _CertificateCard extends StatefulWidget {
  final Certificate certificate;

  const _CertificateCard({required this.certificate});

  @override
  State<_CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<_CertificateCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
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
            child: Card(
              color: AppColors.cardBackground.withOpacity(0.3), // Lower opacity for translucency
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      widget.certificate.imageUrl,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.background.withOpacity(0.5), // Fallback also translucent
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary.withOpacity(0.5)),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: AppPaddings.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.certificate.title,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.certificate.issuer,
                            style: AppTextStyles.bodyText(context).copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Issued: ${widget.certificate.issueDate}',
                            style: AppTextStyles.bodyText(context).copyWith(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(), // Pushes button to the bottom
                          AnimatedOpacity(
                            opacity: _opacityAnimation.value,
                            duration: const Duration(milliseconds: 200),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: widget.certificate.certificateUrl != null
                                    ? () => _launchUrl(widget.certificate.certificateUrl!)
                                    : null, // Disable if no URL
                                icon: const FaIcon(FontAwesomeIcons.solidEye, size: 20),
                                label: const Text('View Certificate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: AppColors.textPrimary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- _SkillCard (copied from skill_section to be accessible here for Tech Stack tab) ---
// This is kept here for now, although the Tech Stack tab is removed.
// You might remove this if you no longer need SkillCard in PortfolioSection.
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
